require 'no_cancelled_invoices'

class AutomaticBan
  # Minimum registration period is three months. Having short ban period
  # that uses the same time should abusers from participating in the most
  # immediate rounds of auctions for a domain name.
  SHORT_BAN_PERIOD_IN_MONTHS = 3
  BAN_PERIOD_IN_MONTHS = Setting.find_by(code: 'ban_length').retrieve

  attr_reader :invoice
  attr_reader :user
  attr_reader :domain_name
  attr_reader :ban
  attr_reader :unpaid_invoices

  def initialize(invoice:, user:, domain_name:)
    @invoice = invoice
    @user = user
    @domain_name = domain_name
  end

  def create
    @unpaid_invoices = Invoice.where(user_id: user, status: Invoice.statuses[:cancelled]).count

    raise Errors::NoCancelledInvoices.new(user.id, domain_name) if unpaid_invoices.zero?

    create_ban
    assign_ban_length
    send_email
    ban
  end

  def create_ban
    @ban = Ban.new(user: user,
                   valid_from: Time.zone.now.to_datetime,
                   invoice: invoice,
                   domain_name: domain_name)
  end

  def assign_ban_length
    now = Time.zone.now.to_datetime
    @ban.update!(valid_from: now,
                 valid_until: now >> BAN_PERIOD_IN_MONTHS)
  end

  def send_email
    if ban.domain_name
      BanMailer.short_ban_mail(@ban, unpaid_invoices, @domain_name).deliver_later
    else
      BanMailer.long_ban_mail(@ban, unpaid_invoices, @domain_name).deliver_later
    end
  end
end
