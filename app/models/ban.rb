class Ban < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :invoice, optional: true

  validates :valid_until, presence: true
  validate :valid_until_later_valid_from

  def valid_until_later_valid_from
    return unless valid_until
    return if valid_until > (valid_from || Time.zone.now)

    errors.add(:valid_until, 'must be later than valid_from')
  end

  scope :valid, lambda {
    where('valid_until >= ? AND valid_from <= ?', Time.now.utc, Time.now.utc)
  }

  scope :with_name, ->(search_string) {
    if search_string.present?
      users = User.where('given_names ILIKE ? OR surname ILIKE ? OR email ILIKE ?',
                         "%#{search_string}%",
                         "%#{search_string}%",
                         "%#{search_string}%").all

      billing_profile = BillingProfile.where('name ILIKE ?', "%#{search_string}%").all
      user_ids = (users.ids + [billing_profile.select(:user_id)]).uniq

      where(user_id: user_ids)
    end
  }

  def self.search(params={})
    self.with_name(params[:search_string])
  end

  def lift
    destroy!
  end
end
