class Ban < ApplicationRecord
  # Minimum registration period is three months. Having short ban period
  # that uses the same time should abusers from participating in the most
  # immediate rounds of auctions for a domain name.
  SHORT_BAN_PERIOD_IN_MONTHS = 3

  # To be changed to a setting.
  LONG_BAN_PERIOD_IN_MONTHS = 100

  belongs_to :user, required: false
  validates :valid_until, presence: true

  def self.create_automatic(user:, domain_name:)
    now = Time.zone.now.to_datetime

    ban = find_or_initialize_by(user: user) do |first_time_ban|
      first_time_ban.domain_name = domain_name
      valid_until = now >> SHORT_BAN_PERIOD_IN_MONTHS
      first_time_ban.valid_until = valid_until
    end

    if ban.persisted?
      valid_until = now >> LONG_BAN_PERIOD_IN_MONTHS
      create!(user: user, valid_until: valid_until)
    else
      ban.save!
      ban
    end
  end

  scope :valid, lambda {
    where('valid_until >= ?', Time.now.utc)
  }

  scope :for_user_and_domain_name, lambda { |user, domain_name = nil|
    where(user: user).where('domain_name = ? OR domain_name IS NULL', domain_name)
  }
end
