module Recommendation
  class ScoreImporter
    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(scores:, scorer_name: nil, features_version: nil, calculated_at: Time.current)
      @scores = Array(scores)
      @scorer_name = scorer_name
      @features_version = features_version
      @calculated_at = calculated_at
    end

    def call
      records = @scores.filter_map { |payload| build_record(payload) }
      return 0 if records.empty?

      UserAuctionScore.upsert_all(records, unique_by: %i[user_id auction_id])
      records.size
    end

    private

    def build_record(payload)
      user_id = resolve_user_id(payload)
      auction_id = resolve_auction_id(payload)
      score = payload[:score] || payload['score']

      return if user_id.blank? || auction_id.blank? || score.blank?

      {
        user_id:,
        auction_id:,
        score: score.to_d,
        scorer_name: payload[:scorer_name] || payload['scorer_name'] || @scorer_name,
        features_version: payload[:features_version] || payload['features_version'] || @features_version,
        calculated_at: payload[:calculated_at] || payload['calculated_at'] || @calculated_at,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    def resolve_user_id(payload)
      payload[:user_id] || payload['user_id'] || User.find_by(uuid: payload[:user_uuid] || payload['user_uuid'])&.id
    end

    def resolve_auction_id(payload)
      payload[:auction_id] || payload['auction_id'] || Auction.find_by(uuid: payload[:auction_uuid] || payload['auction_uuid'])&.id
    end
  end
end
