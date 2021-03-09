require 'active_support/testing/time_helpers'
class BansUtil
  include ActiveSupport::Testing::TimeHelpers
  def create_ban_with_offence(user)
    travel_to Time.zone.now - 3.days - 1.hour
    invoice, domain_name = create_bannable_offence(user)
    ban = AutomaticBan.new(invoice: invoice, user: user, domain_name: domain_name).create
    [invoice, domain_name, ban]
  end

  def create_bannable_offence(user)
    result = create_result_for_ended_auction_with_offers(user)
    invoice = create_overdue_invoice(result)

    [invoice, result.auction.domain_name]
  end

  def create_result_for_ended_auction_with_offers(user)
    domain_name = "#{SecureRandom.hex(10)}.test"
    day = 86_400

    auction = Auction.new(domain_name: domain_name,
                          starts_at: Time.zone.now - day * 3,
                          ends_at: Time.zone.now - day * 2)

    auction.save(validate: false)

    travel_back
    travel_to(auction.starts_at + 1) do
      Offer.create!(auction: auction,
                    cents: rand(1000) + Setting.find_by(code: 'auction_minimum_offer').retrieve,
                    user: user, billing_profile: user.billing_profiles.sample)
    end

    travel_to auction.ends_at + 1.minute
    ResultCreator.new(auction.id).call
  end

  def create_overdue_invoice(result)
    invoice = InvoiceCreator.new(result).call

    invoice.update!(status: Invoice.statuses[:cancelled],
                    issue_date: Time.zone.now - 8,
                    due_date: Time.zone.now - 1,
                    uuid: SecureRandom.uuid)

    invoice
  end
end
