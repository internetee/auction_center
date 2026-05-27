module Recommendation
  class EventTracker
    class << self
      def call(...)
        new(...).call
      end

      def track_impressions(user:, auctions:, source:, request: nil)
        now = Time.current
        session_id = request&.session&.id&.to_s
        request_id = request&.request_id

        records = Array(auctions).filter_map do |auction|
          next unless auction&.id

          {
            user_id: user&.id,
            auction_id: auction.id,
            event_type: 'auction_impression',
            source: source,
            session_id: session_id,
            request_id: request_id,
            occurred_at: now,
            properties: {},
            created_at: now,
            updated_at: now
          }
        end

        return if records.empty?

        RecommendationEvent.insert_all(records)
      rescue StandardError => e
        Rails.logger.warn("Recommendation impressions batch insert failed: #{e.message}")
      end
    end

    def initialize(user:, event_type:, auction: nil, source: nil, properties: {}, request: nil)
      @user = user
      @event_type = event_type
      @auction = auction
      @source = source
      @properties = properties || {}
      @request = request
    end

    def call
      RecommendationEvent.create(
        user: @user,
        auction: @auction,
        event_type: @event_type,
        source: @source,
        session_id: @request&.session&.id&.to_s,
        request_id: @request&.request_id,
        occurred_at: Time.current,
        properties: @properties
      )
    rescue StandardError => e
      Rails.logger.warn("Recommendation event tracking failed: #{e.message}")
    end
  end
end
