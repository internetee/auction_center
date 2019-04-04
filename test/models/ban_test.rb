require 'test_helper'

class BanTest < ActiveSupport::TestCase
  def setup
    super

    @time = DateTime.parse('2010-07-05 10:31 +0000')
    travel_to @time

    @user = users(:participant)
    @other_user = users(:second_place_participant)
    @domain_name = 'example.test'
    @ban = Ban.create_automatic(user: @user, domain_name: @domain_name)
  end

  def teardown
    super

    travel_back
  end

  def test_bans_are_based_on_number_of_cancelled_invoices
    _, domain_name = create_bannable_offence(@user)
    ban = Ban.create_automatic(user: @user, domain_name: domain_name)

    assert(ban.persisted?)
    assert_equal(domain_name, ban.domain_name)
    assert_equal(@time >> 3, ban.valid_until)
  end

  def test_ban_for_second_invoice_is_also_short
    create_bannable_offence(@user)
    _, domain_name = create_bannable_offence(@user)
    ban = Ban.create_automatic(user: @user, domain_name: domain_name)

    assert(ban.persisted?)
    assert_equal(domain_name, ban.domain_name)
    assert_equal(@time >> 3, ban.valid_until)
  end

  def test_third_ban_is_long
    create_bannable_offence(@user)
    create_bannable_offence(@user)

    _, domain_name = create_bannable_offence(@user)
    ban = Ban.create_automatic(user: @user, domain_name: domain_name)

    assert(ban.persisted?)
    assert_nil(ban.domain_name)
    assert_equal(@time >> 100, ban.valid_until)
  end

  def test_number_of_ban_offences_before_long_ban_is_configurable_in_settings
    setting = settings(:ban_number_of_strikes)
    setting.update!(value: '1')

    _, domain_name = create_bannable_offence(@user)
    ban = Ban.create_automatic(user: @user, domain_name: domain_name)

    assert(ban.persisted?)
    assert_nil(ban.domain_name)
    assert_equal(@time >> 100, ban.valid_until)
  end

  def test_valid_scope
    assert_equal([@ban].to_set, Ban.valid.to_set)
  end

  def test_valid_until_must_be_later_than_valid_from
    ban = Ban.new(user: @user)

    ban.valid_until = Time.now - 1.day
    refute(ban.valid?)
    assert_equal(ban.errors[:valid_until], ['must be later than valid_from'])

    ban.valid_until = Time.now
    refute(ban.valid?)
    assert_equal(ban.errors[:valid_until], ['must be later than valid_from'])

    ban.valid_until = Time.now + 1.day
    assert(ban.valid?)
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
                    cents: rand(1000) + Setting.auction_minimum_offer,
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
