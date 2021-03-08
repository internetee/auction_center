require 'test_helper'

class AutomaticBanTest < ActiveSupport::TestCase
  def setup
    super

    @time = DateTime.parse('2010-07-05 10:31 +0000')
    travel_to @time

    @user = users(:participant)
    @domain_name = 'example.test'
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_constant
    assert_equal(Setting.find_by(code: 'ban_length').retrieve, AutomaticBan::BAN_PERIOD_IN_MONTHS)
  end

  def test_automatic_ban_on_user_without_overdue_invoices_fails
    ban = AutomaticBan.new(invoice: Invoice.new, user: @user, domain_name: 'some-domain.test')

    assert_raises(Errors::NoCancelledInvoices) do
      ban.create
    end
  end

  def test_bans_are_based_on_number_of_cancelled_invoices
    invoice, domain_name = create_bannable_offence(@user)
    ban = AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert(ban.persisted?)
    assert_equal(invoice, ban.invoice)
    assert_equal(domain_name, ban.domain_name)
    assert_equal(@time >> ban_period, ban.valid_until)
  end

  def test_ban_for_second_invoice_is_also_long
    create_bannable_offence(@user)
    invoice, domain_name = create_bannable_offence(@user)
    ban = AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert(ban.persisted?)
    assert_equal(invoice, ban.invoice)
    assert_equal(domain_name, ban.domain_name)
    assert_equal(@time >> ban_period, ban.valid_until)
  end

  def test_third_ban_is_long_and_have_domain_name
    create_bannable_offence(@user)
    create_bannable_offence(@user)

    invoice, domain_name = create_bannable_offence(@user)
    ban = AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert(ban.persisted?)
    assert_equal(invoice, ban.invoice)
    assert_equal(domain_name, ban.domain_name)
    assert_equal(@time >> ban_period, ban.valid_until)
  end

  def test_number_of_ban_offences_before_long_ban_is_configurable_in_settings
    setting = settings(:ban_number_of_strikes)
    setting.update!(value: '1')

    invoice, domain_name = create_bannable_offence(@user)
    ban = AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert(ban.persisted?)
    assert_equal(@time >> ban_period, ban.valid_until)
    assert(@user.completely_banned?)
  end

  def test_creating_a_ban_sends_an_email
    invoice, domain_name = create_bannable_offence(@user)
    clear_email_deliveries

    AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert_not(ActionMailer::Base.deliveries.empty?)
    last_email = ActionMailer::Base.deliveries.last

    assert_equal("Participation in #{domain_name} auction prohibited", last_email.subject)
    assert_equal(['user@auction.test'], last_email.to)
  end

  # Test helpers start here
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

    travel_to @time
    ResultCreator.new(auction.id).call
  end

  def create_overdue_invoice(result)
    invoice = InvoiceCreator.new(result).call

    invoice.update!(status: Invoice.statuses[:cancelled],
                    issue_date: Time.zone.now - 8,
                    due_date: Time.zone.now - 1)

    invoice
  end

  def ban_period
    AutomaticBan::BAN_PERIOD_IN_MONTHS
  end
end
