require 'test_helper'

class RecommendationEventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    super
    @user = users(:participant)
    @auction = auctions(:valid_without_offers)
    sign_in @user
    RecommendationEvent.delete_all
  end

  def test_records_click_with_truncated_source_and_no_client_properties
    post_event(event_type: 'auction_click', source: 'x' * 500, properties: { amount: 999 })

    assert_response :created
    event = RecommendationEvent.sole
    assert_equal [@user.id, @auction.id, 'auction_click'], [event.user_id, event.auction_id, event.event_type]
    assert_equal 64, event.source.length
    assert_empty event.properties
  end

  def test_rejects_server_side_event_types_and_unknown_auctions
    %w[bid_create wishlist_add recommendation_profile_completed bogus].each do |type|
      post_event(event_type: type)
      assert_response :unprocessable_entity
    end
    post_event(event_type: 'auction_click', auction_uuid: SecureRandom.uuid)
    assert_response :unprocessable_entity

    assert_equal 0, RecommendationEvent.count
  end

  private

  def post_event(event_type:, source: 'ui', auction_uuid: @auction.uuid, properties: nil)
    Feature.stub(:open_ai_integration_enabled?, true) do
      post recommendation_events_path, as: :json,
                                       params: { recommendation_event: { event_type:, source:, auction_uuid:,
                                                                         properties: }.compact }
    end
  end
end
