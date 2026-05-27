require 'test_helper'

class RecommendationDetailViewTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    super
    @user = users(:participant)
    @auction = auctions(:valid_without_offers)
    sign_in @user
    RecommendationEvent.where(event_type: 'auction_detail_view').delete_all
  end

  def test_offers_new_records_detail_view
    assert_difference -> { RecommendationEvent.where(event_type: 'auction_detail_view').count }, 1 do
      get new_auction_offer_path(auction_uuid: @auction.uuid)
    end

    event = RecommendationEvent.where(event_type: 'auction_detail_view').last
    assert_equal @user.id, event.user_id
    assert_equal @auction.id, event.auction_id
    assert_equal 'offers#new', event.source
  end
end
