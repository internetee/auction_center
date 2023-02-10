require 'test_helper'

class AuctionBiddingPerformanceTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper

  def setup
    @auction = auctions(:english)
    @offer = offers(:high_offer)
    @user = users(:participant)

    clear_enqueued_jobs
  end

  def test_english_offers_partial
    signed_name = Turbo::StreamsChannel.signed_stream_name "auctions_offer_#{@auction.id}"
    stream_name = Turbo::StreamsChannel.verified_stream_name signed_name

    Turbo::StreamsChannel.broadcast_render_later_to("auctions_offer_#{@auction.id}",
      template: "english_offers/streams/updated",
      locals: { auction: @auction }
    )

    assert_enqueued_jobs 1
    perform_enqueued_jobs

    assert_broadcasts stream_name, 1
  end

  def test_update_list_broadcast_should_be_in_queue
    signed_name = Turbo::StreamsChannel.signed_stream_name "auctions"
    stream_name = Turbo::StreamsChannel.verified_stream_name signed_name

    Turbo::StreamsChannel.broadcast_render_later_to("auctions",
      template: "auctions/streams/updated_list",
      locals: { auction: @auction }
    )

    assert_enqueued_jobs 1
    perform_enqueued_jobs

    assert_broadcasts stream_name, 1
  end

  def test_update_offer_broadcast_should_be_in_queue
    signed_name = Turbo::StreamsChannel.signed_stream_name "auctions_offer_#{@auction.id}"
    stream_name = Turbo::StreamsChannel.verified_stream_name signed_name

    Turbo::StreamsChannel.broadcast_render_later_to("auctions_offer_#{@auction.id}",
      template: "auctions/streams/updated_offer",
      locals: { auction: @auction }
    )

    assert_enqueued_jobs 1
    perform_enqueued_jobs

    assert_broadcasts stream_name, 1
  end

  def test_replace_offer_broadcast_should_be_in_queue
    signed_name = Turbo::StreamsChannel.signed_stream_name "auctions"
    stream_name = Turbo::StreamsChannel.verified_stream_name signed_name

    Turbo::StreamsChannel.broadcast_render_later_to("auctions",
      template: "english_offers/streams/replaced",
      locals: { offer: @offer }
    )

    assert_enqueued_jobs 1
    perform_enqueued_jobs

    assert_broadcasts stream_name, 1
  end
end
