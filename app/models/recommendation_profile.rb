class RecommendationProfile < ApplicationRecord
  PROMPT_REMINDER_INTERVAL = 14.days
  CUSTOM_INTEREST_PREFIX = 'custom:'.freeze
  OTHER_CATEGORY = 'other'.freeze

  belongs_to :user

  before_validation :normalize_interest_categories

  validates :preferred_length_min,
            numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 63 },
            allow_nil: true
  validates :preferred_length_max,
            numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 63 },
            allow_nil: true
  validate :length_range_is_valid
  validate :interest_categories_are_supported

  SELECTION_ENABLED_SETTING = 'recommendation_interests_enabled'.freeze

  # Admin toggle (Setting). When false, the interest-selection UI is hidden
  # from users (no prompt, no form). Already-saved interests still affect
  # ranking — this only gates the UI. Defaults to false when the setting is
  # missing, so a fresh / un-seeded deploy never shows an empty picker.
  def self.selection_enabled?
    Setting.find_by(code: SELECTION_ENABLED_SETTING)&.retrieve == true
  rescue StandardError
    false
  end

  def completed? = completed_at.present?

  def promptable?
    return false if completed?
    return true if prompt_dismissed_at.blank?

    prompt_dismissed_at <= PROMPT_REMINDER_INTERVAL.ago
  end

  def filled?
    rankable_interest_categories.any? ||
      custom_interests.any? ||
      preferred_length_min.present? ||
      preferred_length_max.present? ||
      !allow_numbers.nil? ||
      !allow_hyphens.nil?
  end

  def mark_completed!
    update!(completed_at: Time.current, prompt_dismissed_at: nil)
  end

  def dismiss_prompt!
    update!(
      prompt_dismissed_at: Time.current,
      last_prompted_at: Time.current,
      prompt_shown_count: prompt_shown_count + 1
    )
  end

  def interest_categories
    interest_keywords.select { |value| known_category?(value) }
  end

  def interest_categories=(values)
    self.interest_keywords = combine_interest_values(categories: values, custom_values: custom_interests)
  end

  def interest_categories_labels
    interest_categories.map { |category| Recommendation::InterestCatalog.label_for(category) }
  end

  def rankable_interest_categories
    interest_categories - [OTHER_CATEGORY]
  end

  def custom_interests
    interest_keywords.filter_map do |value|
      next unless value.to_s.start_with?(CUSTOM_INTEREST_PREFIX)

      value.to_s.delete_prefix(CUSTOM_INTEREST_PREFIX)
    end
  end

  def custom_interests=(values)
    self.interest_keywords = combine_interest_values(categories: interest_categories, custom_values: values)
  end

  def summary_lines
    [].tap do |lines|
      if rankable_interest_categories.any?
        labels = rankable_interest_categories.map { |category| Recommendation::InterestCatalog.label_for(category) }
        lines << "#{I18n.t('recommendation_profiles.summary.categories')}: #{labels.join(', ')}"
      end

      if custom_interests.any?
        lines << "#{I18n.t('recommendation_profiles.summary.custom_interests')}: #{custom_interests.join(', ')}"
      end

      if preferred_length_min.present? || preferred_length_max.present?
        min = preferred_length_min || '?'
        max = preferred_length_max || '?'
        lines << "#{I18n.t('recommendation_profiles.summary.length')}: #{min}-#{max}"
      end
    end
  end

  private

  def normalize_interest_categories
    known_categories = normalize_list(interest_keywords).select { |item| known_category?(item) }
    normalized_custom_interests = normalize_custom_interests(
      interest_keywords.reject { |item| known_category?(item) }
    )

    known_categories << OTHER_CATEGORY if normalized_custom_interests.any?
    self.interest_keywords = (known_categories.uniq + normalized_custom_interests).uniq
  end

  def combine_interest_values(categories:, custom_values:)
    normalized_categories = normalize_list(categories).select { |item| known_category?(item) }
    normalized_custom_interests = normalize_custom_interests(custom_values)

    normalized_categories << OTHER_CATEGORY if normalized_custom_interests.any?
    (normalized_categories.uniq + normalized_custom_interests).uniq
  end

  def normalize_list(value)
    Array(value)
      .flat_map do |item|
        item.is_a?(String) ? item.to_s.split(',') : item
      end
      .map { |item| item.to_s.strip.downcase }
      .reject(&:blank?)
      .uniq
  end

  def normalize_custom_interests(values)
    normalize_list(values).filter_map do |value|
      next if known_category?(value)

      normalized_value = value.delete_prefix(CUSTOM_INTEREST_PREFIX).strip
      next if normalized_value.blank?

      "#{CUSTOM_INTEREST_PREFIX}#{normalized_value}"
    end
  end

  def length_range_is_valid
    return unless preferred_length_min.present? && preferred_length_max.present?
    return if preferred_length_min <= preferred_length_max

    errors.add(:preferred_length_min, :invalid)
  end

  def interest_categories_are_supported
    invalid_categories = interest_keywords.reject do |value|
      known_category?(value) || value.to_s.start_with?(CUSTOM_INTEREST_PREFIX)
    end
    return if invalid_categories.empty?

    errors.add(:interest_keywords, :invalid)
  end

  def known_category?(value)
    Recommendation::InterestCatalog.categories.include?(value.to_s)
  end
end
