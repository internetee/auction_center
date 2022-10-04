require 'test_helper'

class WishlistAutoOfferJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    @user = users(:participant)
    @auction = auctions(:valid_without_offers)
    @item = WishlistItem.create!(user: @user, domain_name: @auction.domain_name)
  end

  def test_offer_is_created
    @item.update!(cents: 5000)
    WishlistAutoOfferJob.perform_now(@item.id, @auction.id)

    assert @user.offers.find_by(auction: @auction).present?
  end

  def test_offer_is_not_created_when_item_does_not_have_cents
    WishlistAutoOfferJob.perform_now(@item.id, @auction.id)

    assert_not @user.offers.find_by(auction: @auction).present?
  end

  def test_it_sends_auto_offer_email
    @item.update!(cents: 5000)

    assert_enqueued_emails(1) do
      WishlistAutoOfferJob.perform_now(@item.id, @auction.id)
    end
  end
end
