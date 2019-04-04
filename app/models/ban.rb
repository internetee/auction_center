class Ban < ApplicationRecord
  # Minimum registration period is three months. Having short ban period
  # that uses the same time should abusers from participating in the most
  # immediate rounds of auctions for a domain name.
  SHORT_BAN_PERIOD_IN_MONTHS = 3

  belongs_to :user, optional: true
  validates :valid_until, presence: true
  validate :valid_until_later_valid_from

  def valid_until_later_valid_from
    return unless valid_until
    return if valid_until > (valid_from || Time.zone.now)

    errors.add(:valid_until, 'must be later than valid_from')
  end

  def self.create_automatic(user:, domain_name:)
    now = Time.zone.now.to_datetime
    unpaid_invoices = Invoice.where(user_id: user, status: Invoice.statuses[:cancelled]).count

    if unpaid_invoices < Setting.ban_number_of_strikes
      short_ban = create!(user: user, domain_name: domain_name, valid_from: now,
                          valid_until: now >> SHORT_BAN_PERIOD_IN_MONTHS)

    elsif unpaid_invoices >= Setting.ban_number_of_strikes
      long_ban = create!(user: user, valid_from: now,
                         valid_until: now >> Setting.ban_length)
    end
  end

  scope :valid, lambda {
    where('valid_until >= ? AND valid_from <= ?', Time.now.utc, Time.now.utc)
  }
end
