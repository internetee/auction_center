require 'test_helper'

class WishlistAutoOfferJobTest < ActiveJob::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    @user = users(:participant)
    @second_user = users(:second_place_participant)
    @auction = auctions(:english)
    # starting_price: 5.0
    # min_bids_step: 0.1
    # slipping_end: 5
  end

  def test_should_increase_min_bids_if_one_of_the_users_has_autobider
    item = WishlistItem.new(user: @second_user, domain_name: @auction.domain_name, cents: 10000, highest_bid: 12000)
    item.save(validate: false)
    item.reload

    assert_equal @auction.min_bids_step.to_f, 5.0

    EnglishAutobiderJob.perform_now(@auction.id, @user.id)

    @auction.reload

    assert_equal @auction.min_bids_step.to_f, 5.1
  end

  def test_should_update_min_bids_after_each_bid
    item = WishlistItem.new(user: @second_user, domain_name: @auction.domain_name, cents: 10000, highest_bid: 12000)
    item.save(validate: false)
    item.reload
    assert_equal @auction.min_bids_step.to_f, 5.0

    EnglishAutobiderJob.perform_now(@auction.id, @user.id)
    @auction.reload
    assert_equal @auction.min_bids_step.to_f, 5.1

    EnglishAutobiderJob.perform_now(@auction.id, @user.id)
    @auction.reload
    assert_equal @auction.min_bids_step.to_f, 5.2
  end

  def test_should_not_increase_more_then_highest_bid
    item = WishlistItem.new(user: @second_user, domain_name: @auction.domain_name, cents: 4000, highest_bid: 4900)
    item.save(validate: false)
    item.reload

    assert_equal @auction.min_bids_step.to_f, 5.0

    EnglishAutobiderJob.perform_now(@auction.id, @user.id)

    @auction.reload

    assert_equal @auction.min_bids_step.to_f, 5.0
    EnglishAutobiderJob.perform_now(@auction.id, @user.id)

    @auction.reload
    assert_equal @auction.min_bids_step.to_f, 5.0
  end

  def test_should_not_autobid_if_user_with_actual_highest_wishlist_make_bid
    item = WishlistItem.new(user: @user, domain_name: @auction.domain_name, cents: 10000, highest_bid: 12000)
    item.save(validate: false)
    item.reload
    assert_equal @auction.min_bids_step.to_f, 5.0

    EnglishAutobiderJob.perform_now(@auction.id, @user.id)
    @auction.reload
    assert_equal @auction.min_bids_step.to_f, 5.0

    EnglishAutobiderJob.perform_now(@auction.id, @user.id)
    @auction.reload
    assert_equal @auction.min_bids_step.to_f, 5.0
  end

  # -------------- serial autobiders for the same auction -----------------

  def test_serial_autobiders_for_the_same_auction
    item = WishlistItem.new(user: @user, domain_name: @auction.domain_name, cents: 500, highest_bid: 12000)
    item.save(validate: false)
    item.reload

    item2 = WishlistItem.new(user: @second_user, domain_name: @auction.domain_name, cents: 500, highest_bid: 14000)
    item2.save(validate: false)
    item2.reload

    assert_equal @auction.min_bids_step.to_f, 5.0

    EnglishAutobiderJob.perform_now(@auction.id, @user.id)
    @auction.reload
    assert_equal @auction.min_bids_step.to_f, 130.0
  end
end
