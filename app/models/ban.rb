class Ban < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :invoice, optional: true

  validates :valid_until, presence: true
  validates :domain_name, format: { with: /\A[a-z0-9\-]+\.[a-z]{2,}\z/i,
                                     message: :invalid_domain_format },
                          allow_blank: true
  validate :valid_until_later_valid_from
  validate :no_active_ban_for_same_domain, on: :create

  def valid_until_later_valid_from
    return unless valid_until
    return if valid_until > (valid_from || Time.zone.now)

    errors.add(:valid_until, 'must be later than valid_from')
  end

  scope :valid, lambda {
    where('valid_until >= ? AND valid_from <= ?', Time.now.utc, Time.now.utc)
  }

  scope :with_name, (lambda do |search_string|
    if search_string.present?
      users = User.where('given_names ILIKE ? OR surname ILIKE ? OR email ILIKE ?',
                         "%#{search_string}%",
                         "%#{search_string}%",
                         "%#{search_string}%").all

      billing_profile = BillingProfile.where('name ILIKE ?', "%#{search_string}%").all
      user_ids = (users.ids + [billing_profile.select(:user_id)]).uniq

      where(user_id: user_ids)
    end
  end)

  def self.search(params = {})
    with_name(params[:search_string])
  end

  def lift
    destroy!
  end

  private

  def no_active_ban_for_same_domain
    return if domain_name.blank?

    existing = Ban.valid.where(user_id: user_id, domain_name: domain_name)
    return unless existing.exists?

    errors.add(:domain_name, :already_banned)
  end
end
