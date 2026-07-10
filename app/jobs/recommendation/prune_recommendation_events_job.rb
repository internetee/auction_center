module Recommendation
  # Retention/cleanup for recommendation_events. The table is append-only and
  # otherwise grows forever. Scoring reads only 'auction_detail_view' events, and
  # those decay (60-day half-life) to a negligible weight well before the
  # retention window, so pruning old rows does not measurably change rankings.
  #
  # Two policies:
  #   - everything older than DEFAULT_RETENTION is dropped;
  #   - 'auction_impression' (never read by the scorer, and by far the highest
  #     volume) is dropped much sooner.
  #
  # Deletes in batches so the first run on a large table never holds a long lock.
  # Exposed on /admin/jobs and as `rake recommendation:prune_events` (cron).
  class PruneRecommendationEventsJob < ApplicationJob
    DEFAULT_RETENTION = 6.months
    IMPRESSION_RETENTION = 1.month
    BATCH_SIZE = 10_000

    def perform(batch_size: BATCH_SIZE)
      return 0 unless RecommendationEvent.table_exists?

      deleted = 0
      deleted += prune(RecommendationEvent.where(occurred_at: ...DEFAULT_RETENTION.ago), batch_size)
      deleted += prune(
        RecommendationEvent.where(event_type: 'auction_impression')
                           .where(occurred_at: ...IMPRESSION_RETENTION.ago),
        batch_size
      )
      Rails.logger.info("PruneRecommendationEventsJob deleted #{deleted} event(s)")
      deleted
    end

    def self.needs_to_run?
      return false unless RecommendationEvent.table_exists?

      RecommendationEvent.where(occurred_at: ...DEFAULT_RETENTION.ago).exists? ||
        RecommendationEvent.where(event_type: 'auction_impression')
                           .where(occurred_at: ...IMPRESSION_RETENTION.ago).exists?
    end

    private

    def prune(scope, batch_size)
      total = 0
      loop do
        count = scope.limit(batch_size).delete_all
        total += count
        break if count < batch_size
      end
      total
    end
  end
end
