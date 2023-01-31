require "test_helper"

class DomainOfferHistoryTest < ActiveSupport::TestCase
  def setup
    @user = users(:participant)
    @user_two = users(:second_place_participant)
    @auction = auctions(:english)
    @blind_auction = auctions(:valid_without_offers)
    @billing_profile1 = billing_profiles(:private_person)
    @billing_profile2 = billing_profiles(:company)

    @auction.ends_at = Time.zone.now + 2.days
    @auction.save && @auction.reload

    @blind_auction.ends_at = Time.zone.now + 2.days
    @blind_auction.save && @blind_auction.reload
  end

  def test_should_be_created_domain_offer_history
    assert_difference -> { DomainOfferHistory.count } do
      Offer.create!(
        auction: @auction,
        user: @user,
        cents: 10000,
        billing_profile: @billing_profile1
      )
    end
  end

  def test_should_be_created_domain_offer_history_with_different_billing_profiles
    DomainOfferHistory.destroy_all
    assert_equal DomainOfferHistory.count, 0

    Offer.create!(
      auction: @auction,
      user: @user,
      cents: 10000,
      billing_profile: @billing_profile1
    )

    Offer.create!(
      auction: @auction,
      user: @user_two,
      cents: 20000,
      billing_profile: @billing_profile2
    )

    assert_equal DomainOfferHistory.count, 2
    history1 = DomainOfferHistory.first
    history2 = DomainOfferHistory.second

    assert_equal history1.bid_in_cents, 10000
    assert_equal history2.bid_in_cents, 20000
  end

  def test_not_create_histroy_for_blind_auction
    assert_no_difference -> { DomainOfferHistory.count } do
      Offer.create!(
        auction: @blind_auction,
        user: @user,
        cents: 10000,
        billing_profile: @billing_profile1
      )
    end
  end

  def test_should_create_history_snapshot_after_update_bill
    DomainOfferHistory.destroy_all
    assert_equal DomainOfferHistory.count, 0

    offer1 = Offer.new(
      auction: @auction,
      user: @user,
      cents: 10_000,
      billing_profile: @billing_profile1
    )
    offer1.save

    Offer.create!(
      auction: @auction,
      user: @user_two,
      cents: 20_000,
      billing_profile: @billing_profile2
    )

    offer1.cents = 30_000
    offer1.save && offer1.reload

    assert_equal DomainOfferHistory.count, 3
    history1 = DomainOfferHistory.first
    history2 = DomainOfferHistory.second
    history3 = DomainOfferHistory.third 

    assert_equal history1.billing_profile, history3.billing_profile
    assert_equal history1.bid_in_cents, 10_000
    assert_equal history3.bid_in_cents, 30_000

    assert_equal history2.billing_profile, @billing_profile2
    assert_equal history2.bid_in_cents, 20_000
  end
end
