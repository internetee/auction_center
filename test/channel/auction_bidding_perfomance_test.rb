require 'test_helper'

class AuctionBiddingPerformanceTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper

  def setup
    @auction = auctions(:english)
    @user = users(:participant)
  end

  def test_broadcast_should_be_in_queue
    Turbo::StreamsChannel.broadcast_render_later_to("auctions_offer_#{@auction.id}",
      template: "english_offers/streams/updated",
      locals: { auction: @auction }
    )

    assert_enqueued_jobs 1
  end
end

