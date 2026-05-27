require 'test_helper'

module Recommendation
  class EventTrackerTest < ActiveSupport::TestCase
    def setup
      super
      @user = users(:participant)
      @auction_a = auctions(:valid_without_offers)
      @auction_b = auctions(:valid_with_offers)
    end

    def test_track_impressions_inserts_all_events_in_single_query
      RecommendationEvent.where(user: @user, event_type: 'auction_impression').delete_all

      assert_difference -> { RecommendationEvent.count }, 2 do
        Recommendation::EventTracker.track_impressions(
          user: @user,
          auctions: [@auction_a, @auction_b],
          source: 'test_index'
        )
      end

      events = RecommendationEvent.where(user: @user, event_type: 'auction_impression').to_a
      assert_equal %w[auction_impression auction_impression], events.map(&:event_type)
      assert_equal [@auction_a.id, @auction_b.id].sort, events.map(&:auction_id).sort
      assert events.all? { |e| e.source == 'test_index' }
    end

    def test_track_impressions_uses_single_insert_query
      query_count = 0
      counter = ->(_name, _start, _finish, _id, payload) do
        sql = payload[:sql].to_s
        query_count += 1 if sql.start_with?('INSERT INTO "recommendation_events"')
      end

      ActiveSupport::Notifications.subscribed(counter, 'sql.active_record') do
        Recommendation::EventTracker.track_impressions(
          user: @user,
          auctions: [@auction_a, @auction_b],
          source: 'test_index'
        )
      end

      assert_equal 1, query_count, 'track_impressions must batch all rows into one INSERT'
    end

    def test_track_impressions_skips_empty_input
      assert_no_difference -> { RecommendationEvent.count } do
        Recommendation::EventTracker.track_impressions(
          user: @user,
          auctions: [],
          source: 'test_index'
        )
      end
    end

    def test_track_impressions_skips_nil_auctions
      assert_difference -> { RecommendationEvent.count }, 1 do
        Recommendation::EventTracker.track_impressions(
          user: @user,
          auctions: [nil, @auction_a, nil],
          source: 'test_index'
        )
      end
    end
  end
end
