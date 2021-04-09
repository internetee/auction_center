require 'no_cancelled_invoices'

class AutomaticBan
  # Minimum registration period is three months. Having short ban period
  # that uses the same time should abusers from participating in the most
  # immediate rounds of auctions for a domain name.
  BAN_PERIOD_IN_MONTHS = Setting.find_by(code: 'ban_length').retrieve
  BAN_NUMBER_OF_STRIKES = Setting.find_by(code: 'ban_number_of_strikes')

  attr_reader :invoice
  attr_reader :user
  attr_reader :domain_name
  attr_reader :ban
  attr_reader :unpaid_invoices_ids
  attr_reader :existing_bans_ids

  def initialize(invoice:, user:, domain_name:)
    @invoice = invoice
    @user = user
    @domain_name = domain_name
  end

  def create
    @unpaid_invoices_ids = Invoice.where(user_id: user, status: Invoice.statuses[:cancelled])
                                  .pluck(:id)
    @existing_bans_ids = Ban.where(invoice_id: @unpaid_invoices_ids).pluck(:id)

    if @unpaid_invoices_ids.count == @existing_bans_ids.count
      raise Errors::NoCancelledInvoices.new(user.id, domain_name)
    end

    create_ban
    assign_ban_length
    send_email
    remove_offer_from_active_auction
    remove_offers_from_active_auctions
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
    BanMailer.ban_mail(@ban, unpaid_invoices_ids.count, @domain_name).deliver_later
  end

  def remove_offer_from_active_auction
    auction = Auction.find_by(domain_name: @domain_name)

    return unless auction.present?
    return unless auction.in_progress?
    
    offer = @user.offers.find_by(auction_id: auction.id)
    offer.destroy if offer.present?
  end

  def remove_offers_from_active_auctions
    ban_number_of_strikes = Setting.find_by(code: 'ban_number_of_strikes')
    return unless ban_number_of_strikes.value.to_i <= @user.bans.count
    
    @user.offers.each do |offer|
      auction_id = offer.auction_id
      auction = Auction.find(auction_id)
      offer.destroy
    end
  end
end
