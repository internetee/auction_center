require 'test_helper'

module Recommendation
  class DatasetSnapshotTest < ActiveSupport::TestCase
    def setup
      super
      @user = users(:participant)
      @auction = auctions(:valid_without_offers)
      @auction.update!(classification_tags: %w[shop_brand local_service], primary_category: 'shop_brand')

      @user.create_recommendation_profile!(
        interest_keywords: %w[legal other custom:marketplace]
      )

      RecommendationEvent.create!(
        user: @user,
        auction: @auction,
        event_type: 'auction_click',
        source: 'test',
        occurred_at: Time.current,
        properties: { foo: 'bar' }
      )

      WishlistItem.create!(user: @user, domain_name: @auction.domain_name, cents: 2000)
    end

    def test_snapshot_contains_users_auctions_and_interactions
      snapshot = DatasetSnapshot.call(
        users: User.where(id: @user.id),
        auctions: Auction.where(id: @auction.id),
        recommendation_events: RecommendationEvent.where(user_id: @user.id)
      )

      assert_equal 1, snapshot[:users].size
      assert_equal @user.uuid, snapshot[:users].first[:user_uuid]
      assert_equal %w[legal other], snapshot[:users].first[:interest_categories]
      assert_equal ['marketplace'], snapshot[:users].first[:custom_interests]

      assert_equal 1, snapshot[:auctions].size
      assert_equal @auction.uuid, snapshot[:auctions].first[:auction_uuid]
      assert_equal %w[shop_brand local_service], snapshot[:auctions].first[:classification_tags]

      event_types = snapshot[:interactions].map { |item| item[:event_type] }
      assert_includes event_types, 'auction_click'
      assert_includes event_types, 'historical_wishlist'
    end
  end
end
