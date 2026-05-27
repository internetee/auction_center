module Recommendation
  class DatasetSnapshot
    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(users: User.all, auctions: Auction.all, recommendation_events: RecommendationEvent.all)
      @users = users
      @auctions = auctions
      @recommendation_events = recommendation_events
    end

    def call
      {
        users: users_payload,
        auctions: auctions_payload,
        interactions: interactions_payload
      }
    end

    private

    def users_payload
      @users.includes(:recommendation_profile).map do |user|
        profile = user.recommendation_profile

        {
          user_uuid: user.uuid,
          locale: user.locale,
          country_code: user.country_code,
          daily_summary: user.daily_summary,
          interest_categories: profile&.interest_categories || [],
          custom_interests: profile&.custom_interests || [],
          preferred_length_min: profile&.preferred_length_min,
          preferred_length_max: profile&.preferred_length_max
        }
      end
    end

    def auctions_payload
      @auctions.map do |auction|
        {
          auction_uuid: auction.uuid,
          domain_name: auction.domain_name,
          platform: auction.platform || 'blind',
          starts_at: auction.starts_at,
          ends_at: auction.ends_at,
          turns_count: auction.turns_count,
          ai_score: auction.ai_score,
          classification_tags: auction.classification_tags,
          primary_category: auction.primary_category,
          classification_source: auction.classification_source,
          classified_at: auction.classified_at,
          starting_price: auction.starting_price,
          min_bids_step: auction.min_bids_step,
          slipping_end: auction.slipping_end,
          enable_deposit: auction.enable_deposit,
          requirement_deposit_in_cents: auction.requirement_deposit_in_cents
        }
      end
    end

    def interactions_payload
      explicit_interactions + historical_offer_interactions + historical_wishlist_interactions
    end

    def explicit_interactions
      @recommendation_events.includes(:user, :auction).map do |event|
        {
          user_uuid: event.user&.uuid,
          auction_uuid: event.auction&.uuid,
          event_type: event.event_type,
          source: event.source,
          occurred_at: event.occurred_at,
          properties: event.properties
        }
      end
    end

    def historical_offer_interactions
      Offer.includes(:user, :auction).map do |offer|
        {
          user_uuid: offer.user&.uuid,
          auction_uuid: offer.auction&.uuid,
          event_type: 'historical_bid',
          source: 'offers',
          occurred_at: offer.updated_at,
          properties: { cents: offer.cents, billing_profile_id: offer.billing_profile_id, username: offer.username }
        }
      end
    end

    def historical_wishlist_interactions
      auctions_by_domain = Auction.where(domain_name: WishlistItem.select(:domain_name).distinct)
                                 .index_by(&:domain_name)

      WishlistItem.includes(:user).filter_map do |item|
        auction = auctions_by_domain[item.domain_name]

        {
          user_uuid: item.user&.uuid,
          auction_uuid: auction&.uuid,
          event_type: 'historical_wishlist',
          source: 'wishlist_items',
          occurred_at: item.updated_at,
          properties: { domain_name: item.domain_name, cents: item.cents }
        }
      end
    end
  end
end
