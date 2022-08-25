class Setting < ApplicationRecord
  include Concerns::FormatValidator
  validates :code, presence: true, uniqueness: true
  validates :description, presence: true
  validates :value, presence: true
  validates :value_format, presence: true
  validate :valid_value_format

  VALUE_FORMATS = {
    string: :string_format,
    integer: :integer_format,
    boolean: :boolean_format,
    hash: :hash_format,
    array: :array_format,
  }.with_indifferent_access.freeze

  # def self.default_scope
  #   Rails.cache.fetch(['cached_', name.underscore.to_s, 's']) { all.load }
  # end

  after_commit :clear_cache

  def clear_cache
    Rails.cache.delete(['cached_', self.class.name.underscore.to_s, 's'])
  end

  def retrieve
    method = VALUE_FORMATS[value_format]
    send(method)
  end

  def valid_value_format
    formats = VALUE_FORMATS.with_indifferent_access
    errors.add(:value_format, :invalid) unless formats.keys.any? value_format
  end

  def string_format
    return auction_duration_value if code == 'auction_duration'
    return auctions_start_at_value if code == 'auctions_start_at'

    value
  end

  def integer_format
    value.to_i
  end

  def boolean_format
    value == 'true'
  end

  def hash_format
    if %w[terms_and_conditions_link violations_count_regulations_link].include? code
      return localized_hash_value
    end

    JSON.parse(value)
  end

  def localized_hash_value
    JSON.parse(value)[I18n.locale.to_s]
  end

  def array_format
    JSON.parse(value).to_a
  end

  def auction_duration_value
    if value == 'end_of_day'
      :end_of_day
    else
      value.to_i
    end
  end

  def auctions_start_at_value
    if value == 'false'
      false
    else
      value.to_i
    end
  end
end
