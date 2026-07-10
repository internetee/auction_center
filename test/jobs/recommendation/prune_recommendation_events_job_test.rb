require 'test_helper'

module Recommendation
  class PruneRecommendationEventsJobTest < ActiveJob::TestCase
    def setup
      super
      RecommendationEvent.delete_all
    end

    def test_deletes_events_older_than_default_retention
      old = event('auction_detail_view', 7.months.ago)
      recent = event('auction_detail_view', 3.months.ago)

      Recommendation::PruneRecommendationEventsJob.new.perform

      refute RecommendationEvent.exists?(old.id), 'event past retention should be pruned'
      assert RecommendationEvent.exists?(recent.id), 'recent scoring event should be kept'
    end

    def test_prunes_impressions_on_the_shorter_window
      stale_impression = event('auction_impression', 2.months.ago)
      fresh_impression = event('auction_impression', 2.weeks.ago)

      Recommendation::PruneRecommendationEventsJob.new.perform

      refute RecommendationEvent.exists?(stale_impression.id), 'impression past 1 month should be pruned'
      assert RecommendationEvent.exists?(fresh_impression.id), 'recent impression should be kept'
    end

    def test_needs_to_run_reflects_pending_rows
      refute Recommendation::PruneRecommendationEventsJob.needs_to_run?, 'empty table needs no run'

      event('auction_detail_view', 7.months.ago)
      assert Recommendation::PruneRecommendationEventsJob.needs_to_run?
    end

    def test_batching_deletes_everything_past_retention
      3.times { event('auction_detail_view', 8.months.ago) }

      deleted = Recommendation::PruneRecommendationEventsJob.new.perform(batch_size: 2)

      assert_equal 3, deleted
      assert_equal 0, RecommendationEvent.where(event_type: 'auction_detail_view').count
    end

    private

    def event(type, occurred_at)
      RecommendationEvent.create!(event_type: type, occurred_at: occurred_at)
    end
  end
end
