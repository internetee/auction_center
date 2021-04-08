require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @valid_auction = auctions(:valid_with_offers)
    @billing_profile = billing_profiles(:company)
    @user = users(:participant)
    @offer = offers(:expired_offer)

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  def test_bind_should_be_cancelled
    auction_related_to_user = Auction.find_by(id: '303038671')

    # do auction active?
    assert auction_related_to_user.ends_at > Time.now

    assert @user.offers.find_by(auction_id: auction_related_to_user.id).present?

    Ban.create!(valid_from: Time.zone.now - 1, valid_until: Time.zone.now + 60,
    user: @user, domain_name: auction_related_to_user.domain_name)

    assert_equal @user.bans.count, 1
    assert_not @user.offers.find_by(auction_id: auction_related_to_user.id).present?
  end

  def test_all_bind_should_be_cancelled_if_user_has_long_ban
    auctions(:with_invoice).update(ends_at: Time.now + 1.day)

    auctions_arr = [auctions(:valid_with_offers), auctions(:valid_without_offers), auctions(:with_invoice)]

    @ban_number_of_strikes.to_i.times do |i|
      # do auctions active? 
      assert auctions_arr[i].ends_at > Time.now

      Ban.create!(valid_from: Time.zone.now - 1, valid_until: Time.zone.now + 60,
      user: @user, domain_name: auctions_arr[i].domain_name)
    end

    assert_equal @user.bans.count, 3
    assert_equal @user.offers, 0
  end

  def test_required_fields
    offer = Offer.new

    assert_not(offer.valid?)
    assert_equal(['must exist', 'must be active'], offer.errors[:auction])
    assert_equal(['is not a number'], offer.errors[:cents])
    assert_equal(['must exist'], offer.errors[:billing_profile])

    offer.auction = @valid_auction
    offer.billing_profile = @billing_profile
    offer.cents = 1201

    assert(offer.valid?)
  end

  def test_auction_needs_to_be_active_to_create_an_offer
    offer = Offer.new

    offer.auction = @expired_auction
    offer.user = @user

    assert_not(offer.valid?(:create))
    assert_equal(['must be active'], offer.errors[:auction])
  end

  def test_cents_must_be_an_integer
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = 12.00

    assert_not(offer.valid?)

    assert_equal(['must be an integer'], offer.errors[:cents])
  end

  def test_cents_must_be_positive
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = -100

    assert_not(offer.valid?)
    assert_equal(['must be greater than 0'], offer.errors[:cents])
  end

  def test_total
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = 1
    offer.billing_profile = @billing_profile

    offer.cents = 500

    assert_equal(offer.total, Money.new('500', 'EUR'))

    offer.billing_profile = billing_profiles(:private_person)
    assert_equal(offer.total, Money.new('600', 'EUR'))
  end

  def test_total_work_as_expected_if_billing_profile_was_deleted
    # vat - taxi
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = 1
    offer.billing_profile = @billing_profile

    offer.cents = 500

    assert_equal(offer.total, Money.new('500', 'EUR'))

    offer.billing_profile = billing_profiles(:private_person)
    assert_equal(offer.total, Money.new('600', 'EUR'))

    offer.billing_profile = nil
    assert_equal(offer.total, Money.new('600', 'EUR'))
  end	

  def test_offer_must_be_higher_than_minimum_value_allowed_in_settings
    offer = Offer.new
    offer.auction = @valid_auction
    offer.user = @user
    offer.cents = 1
    offer.billing_profile = @billing_profile

    assert_not(offer.valid?)
    assert_equal(['must be higher than 5.00'], offer.errors[:price])

    offer.cents = 500
    assert(offer.valid?)
  end

  def test_can_be_orphaned_by_a_user
    @user.destroy
    @offer.reload

    assert_nil(@offer.user)
    assert_nil(@offer.user_id)
  end
end
