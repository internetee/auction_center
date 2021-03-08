if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.command_name 'test'
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'
require 'webmock/minitest'

class ActiveSupport::TestCase
  WebMock.allow_net_connect!
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def clear_email_deliveries
    ActionMailer::Base.deliveries.clear
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

    travel_to DateTime.parse('2010-07-05 10:31 +0000')
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

  def ban_period
    AutomaticBan::BAN_PERIOD_IN_MONTHS
  end
end
