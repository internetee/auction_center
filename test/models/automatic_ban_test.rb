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

  def test_automatic_ban_on_user_without_overdue_invoices_fails
    ban = AutomaticBan.new(invoice: Invoice.new, user: @user, domain_name: 'some-domain.test')

    assert_raises(Errors::NoCancelledInvoices) do
      ban.create
    end
  end

  def test_bans_are_based_on_number_of_cancelled_invoices_without_bans
    invoice, domain_name = create_bannable_offence(@user)
    ban = AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert(ban.persisted?)
    assert_equal(invoice, ban.invoice)
    assert_equal(domain_name, ban.domain_name)
    assert_equal(@time >> Setting.find_by(code: 'ban_length').retrieve, ban.valid_until)
  end

  def test_ban_without_bannable_invoice_fails
    invoice, domain_name = create_bannable_offence(@user)
    AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create
    ban = AutomaticBan.new(invoice: Invoice.new, user: @user, domain_name: 'some-domain.test')

    assert_raises(Errors::NoCancelledInvoices) do
      ban.create
    end
  end

  def test_ban_for_second_invoice_is_also_long
    create_bannable_offence(@user)
    invoice, domain_name = create_bannable_offence(@user)
    ban = AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert(ban.persisted?)
    assert_equal(invoice, ban.invoice)
    assert_equal(domain_name, ban.domain_name)
    assert_equal(@time >> Setting.find_by(code: 'ban_length').retrieve, ban.valid_until)
  end

  def test_third_ban_is_long
    create_bannable_offence(@user)
    create_bannable_offence(@user)

    invoice, domain_name = create_bannable_offence(@user)
    ban = AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert(ban.persisted?)
    assert_equal(invoice, ban.invoice)
    assert_equal(domain_name, ban.domain_name)
    assert_equal(@time >> Setting.find_by(code: 'ban_length').retrieve, ban.valid_until)
  end

  def test_number_of_ban_offences_before_long_ban_is_configurable_in_settings
    setting = settings(:ban_number_of_strikes)
    setting.update!(value: '1')

    invoice, domain_name = create_bannable_offence(@user)
    ban = AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert(ban.persisted?)
    assert_equal(@time >> 100, ban.valid_until)
  end

  def test_creating_a_short_ban_sends_an_email
    invoice, domain_name = create_bannable_offence(@user)
    clear_email_deliveries

    AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert_not(ActionMailer::Base.deliveries.empty?)
    last_email = ActionMailer::Base.deliveries.last

    assert_equal("Participation in #{domain_name} auction prohibited", last_email.subject)
    assert_equal(['user@auction.test'], last_email.to)
  end

  def test_creating_a_long_ban_sends_an_email
    create_bannable_offence(@user)
    create_bannable_offence(@user)

    invoice, domain_name = create_bannable_offence(@user)
    clear_email_deliveries

    AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name).create

    assert_not(ActionMailer::Base.deliveries.empty?)
    last_email = ActionMailer::Base.deliveries.last

    assert_equal("Participation in #{domain_name} auction prohibited", last_email.subject)
    assert_equal(['user@auction.test'], last_email.to)
  end

  def test_automatic_ban_clear_for_active_bid_of_active_auction
    invoice, domain_name = create_bannable_offence(@user)
    auction = Auction.find_by(domain_name: domain_name)
    auction.update(starts_at: Time.now - 2.days, ends_at: Time.now + 1.day)

    ban = AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name)
    
    ban.create
    offer = @user.offers.find_by(auction_id: auction.id)
    assert_not offer.present?
  end

  def test_automatic_ban_clear_or_active_bids_for_long_ban
    invoice, domain_name1 = create_bannable_offence(@user)
    invoice, domain_name2 = create_bannable_offence(@user)
    invoice, domain_name3 = create_bannable_offence(@user)
    invoice, domain_name4 = create_bannable_offence(@user)

    auction1 = make_auction(domain_name1)
    auction2 = make_auction(domain_name2)
    auction3 = make_auction(domain_name3)
    auction4 = make_auction(domain_name4)

    assert @user.offers.find_by(auction_id: auction1.id).present?
    assert @user.offers.find_by(auction_id: auction2.id).present?
    assert @user.offers.find_by(auction_id: auction3.id).present?
    assert @user.offers.find_by(auction_id: auction4.id).present?

    AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name1).create
    AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name2).create
    AutomaticBan.new(invoice: invoice, user: @user, domain_name: domain_name3).create

    assert @user.completely_banned?

    assert auction1.in_progress?
    assert auction2.in_progress?
    assert auction3.in_progress?
    assert auction4.in_progress?

    assert_equal @user.bans.count, 3

    assert_not @user.offers.find_by(auction_id: auction1.id).present?
    assert_not @user.offers.find_by(auction_id: auction2.id).present?
    assert_not @user.offers.find_by(auction_id: auction3.id).present?
    assert_not @user.offers.find_by(auction_id: auction4.id).present?
  end

  private
  # Test helpers start here
  def make_auction(domain_name)
    auction = Auction.find_by(domain_name: domain_name)
    auction.update(starts_at: Time.now - 2.days, ends_at: Time.now + 1.day)
    auction
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
end
