class ContentHelper
  def self.create_result(user)
    domain_name = "#{SecureRandom.hex(10)}.test"

    auction = Auction.new(domain_name: domain_name,
                          starts_at: Time.zone.now - day * 3,
                          ends_at: Time.zone.now - day * 2)

    auction.save(validate: false)

    offer = Offer.new(auction: auction,
                      cents: rand(1000) + minimum_offer,
                      user: user,
                      billing_profile: user.billing_profiles.sample)

    offer.save(validate: false)

    ResultCreator.new(auction.id).call
  end

  def self.create_invoice(result)
    invoice = InvoiceCreator.new(result).call

    invoice.update!(status: Invoice.statuses[:issued],
                    issue_date: Time.zone.now - 8.days,
                    due_date: Time.zone.now + 10.days)

    invoice
  end

  def self.minimum_offer
    Setting.find_by(code: 'auction_minimum_offer').retrieve
  end
end
