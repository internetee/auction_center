class AutomaticBan
  # Minimum registration period is three months. Having short ban period
  # that uses the same time should abusers from participating in the most
  # immediate rounds of auctions for a domain name.
  SHORT_BAN_PERIOD_IN_MONTHS = 3

  attr_reader :user
  attr_reader :domain_name
  attr_reader :ban

  def initialize(user:, domain_name:)
    @user = user
    @domain_name = domain_name
  end

  def create
    now = Time.zone.now.to_datetime
    unpaid_invoices = Invoice.where(user_id: user, status: Invoice.statuses[:cancelled]).count

    if unpaid_invoices < Setting.ban_number_of_strikes
      @ban = Ban.create!(user: user, domain_name: domain_name, valid_from: now,
                          valid_until: now >> SHORT_BAN_PERIOD_IN_MONTHS)

    elsif unpaid_invoices >= Setting.ban_number_of_strikes
      @ban = Ban.create!(user: user, valid_from: now,
                         valid_until: now >> Setting.ban_length)
    end

    if ban.domain_name
      BanMailer.short_ban_mail(@ban, unpaid_invoices, @domain_name).deliver_later
    else
      BanMailer.long_ban_mail(@ban, unpaid_invoices, @domain_name).deliver_later
    end

    ban
  end
end
