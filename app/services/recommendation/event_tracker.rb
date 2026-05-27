module Recommendation
  class EventTracker
    class << self
      def call(...)
        new(...).call
      end

      def track_impressions(user:, auctions:, source:, request: nil)
        Array(auctions).each do |auction|
          call(user:, auction:, event_type: 'auction_impression', source:, request:)
        end
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
      Rails.logger.info("Recommendation event tracking failed: #{e.message}")
    end
  end
end
