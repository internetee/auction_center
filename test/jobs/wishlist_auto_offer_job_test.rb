require 'test_helper'

class WishlistAutoOfferJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    @user = users(:participant)
    @user_two = users(:second_place_participant)
    @auction = auctions(:valid_without_offers)
    @item = WishlistItem.create!(user: @user, domain_name: @auction.domain_name)
  end

  def test_offer_is_not_created_when_item_does_not_have_cents
    WishlistAutoOfferJob.perform_now(@item.id, @auction.id)

    assert_not @user.offers.find_by(auction: @auction).present?
  end

  def test_crete_first_bid_from_wishlist
    WishlistItem.destroy_all
    WishlistItem.create!(user: @user, domain_name: @auction.domain_name, cents: 1000)
    WishlistAutoOfferJob.perform_now(@auction.id)
    @auction.reload

    assert_equal @auction.offers.count, 1
    assert_equal @auction.offers.last.cents, 1000
    assert_equal @auction.offers.last.user, @user
  end
end
