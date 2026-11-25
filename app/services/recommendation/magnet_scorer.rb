module Recommendation
  # Recommendation::MagnetScorer (v3, live engine)
  # ----------------------------------------------
  # Computes the "unified embedding" score described in
  # docs/planning/recommendation-v3-unified-embedding-plan.md. This is the LIVE
  # ranking engine: Recommendation::Scorer delegates its `magnet_base` to this
  # class, scales the result ×100, adds structural nudges, and persists it into
  # user_auction_scores — which Auction::UserSortable joins to order /auctions.
  #
  # The user is a *set of magnets*, each a (vector, weight) pair:
  #   - every bid domain      → weight 3.0, time-decayed
  #   - every wishlist domain → weight 3.0, time-decayed
  #   - every selected category (its embedding)     → weight 2.0, no decay
  #   - every custom interest (its cached embedding) → weight 2.0, no decay
  #   - every viewed domain   → weight 1.0, time-decayed
  #
  # A candidate auction's score is the mean of its two strongest pulls, where
  #   pull(magnet) = magnet.weight * cosine(magnet.vector, auction.embedding).
  # top-2 (not raw max) keeps a single lucky magnet from deciding everything.
  #
  # Score is nil (→ auction falls to the ai_score/random tail) when the auction
  # has no embedding or the user has no usable magnet.
  #
  # NOTE: signal queries here mirror those the Scorer would otherwise need; the
  # two classes are kept separate so the pure embedding/behavioural computation
  # (this class) stays independent of the structural scoring layer (Scorer).
  class MagnetScorer
    HALF_LIFE_DAYS = 60.0

    BID_WEIGHT = 3.0
    WISHLIST_WEIGHT = 3.0
    CATEGORY_WEIGHT = 2.0
    CUSTOM_WEIGHT = 2.0
    VIEW_WEIGHT = 1.0

    # Cap behavioural magnets by weight×freshness so a long history can't bloat
    # the per-candidate cosine loop. Categories/custom are never capped.
    MAX_BEHAVIOURAL_MAGNETS = 30
    # Average the N strongest pulls (tuning knob — see plan §3.4).
    TOP_PULLS = 2

    FEATURES_VERSION = 'unified_v3'.freeze

    Anchor = Struct.new(:vector, :weight)

    def self.default_scope
      Auction.active
    end

    def initialize(user:, scope: self.class.default_scope, calculated_at: Time.current)
      @user = user
      @scope = scope
      @calculated_at = calculated_at
    end

    # { auction_id => Float|nil }
    def scores
      auctions.each_with_object({}) { |auction, acc| acc[auction.id] = score_for(auction) }
    end

    # [[auction, score], …] highest first, nil scores dropped.
    def ranked(limit: nil)
      scored = auctions.filter_map do |auction|
        score = score_for(auction)
        [auction, score] unless score.nil?
      end
      scored.sort_by! { |_, score| -score }
      limit ? scored.first(limit) : scored
    end

    private

    def score_for(auction)
      return nil unless @user

      vector = auction_embeddings[auction.id]
      return nil if vector.nil?
      return nil if magnets.empty?

      pulls = magnets.filter_map do |anchor|
        similarity = Recommendation::Embedding.cosine_similarity(anchor.vector, vector)
        next if similarity.nil?

        anchor.weight * similarity
      end
      return nil if pulls.empty?

      strongest = pulls.max(TOP_PULLS)
      (strongest.sum / strongest.size).round(6)
    end

    # ---------- Magnets --------------------------------------------------

    def magnets
      @magnets ||= behavioural_magnets + category_magnets + custom_magnets
    end

    def behavioural_magnets
      weighted_signals =
        bid_signals.map { |signal| [signal, BID_WEIGHT] } +
        wishlist_signals.map { |signal| [signal, WISHLIST_WEIGHT] } +
        view_signals.map { |signal| [signal, VIEW_WEIGHT] }
      return [] if weighted_signals.empty?

      embeddings = domain_embeddings(weighted_signals.map { |signal, _| signal[:domain_name] }.uniq)

      anchors = weighted_signals.filter_map do |signal, base_weight|
        vector = embeddings[signal[:domain_name]]
        next if vector.nil?

        Anchor.new(vector, base_weight * decay_weight(signal[:age_days]))
      end

      anchors.sort_by { |anchor| -anchor.weight }.first(MAX_BEHAVIOURAL_MAGNETS)
    end

    def category_magnets
      return [] unless InterestCategory.column_names.include?('embedding')

      codes = Array(profile&.rankable_interest_categories)
      return [] if codes.empty?

      InterestCategory
        .active
        .where(code: codes)
        .where.not(embedding: nil)
        .pluck(:embedding)
        .filter_map { |vector| build_anchor(vector, CATEGORY_WEIGHT) }
    end

    def custom_magnets
      return [] unless RecommendationProfile.column_names.include?('custom_interest_vectors')

      Array(profile&.custom_interest_vectors).filter_map do |entry|
        vector = entry['embedding'] || entry[:embedding]
        build_anchor(vector, CUSTOM_WEIGHT)
      end
    end

    def build_anchor(vector, weight)
      vector = Array(vector)
      return nil if vector.empty?

      Anchor.new(vector, weight)
    end

    # ---------- Embeddings preload ---------------------------------------

    def auction_embeddings
      @auction_embeddings ||= begin
        by_domain = domain_embeddings(auctions.map { |auction| auction.domain_name.to_s.downcase }.uniq)
        auctions.each_with_object({}) do |auction, acc|
          acc[auction.id] = by_domain[auction.domain_name.to_s.downcase]
        end
      end
    end

    def domain_embeddings(domain_names)
      return {} if domain_names.empty?
      return {} unless DomainClassification.column_names.include?('embedding')

      DomainClassification
        .where(domain_name: domain_names)
        .where.not(embedding: nil)
        .index_by { |dc| dc.domain_name.to_s.downcase }
        .transform_values { |dc| Array(dc.embedding).presence }
        .compact
    end

    # ---------- Signal collection (mirrors Scorer) -----------------------

    def bid_signals
      @bid_signals ||=
        Offer
        .joins(:auction)
        .where(user_id: @user.id)
        .pluck(Arel.sql('LOWER(auctions.domain_name)'), Arel.sql('offers.updated_at'))
        .map { |domain, time| { domain_name: domain, age_days: age_in_days(time) } }
    end

    def wishlist_signals
      @wishlist_signals ||=
        @user.wishlist_items
             .pluck(Arel.sql('LOWER(wishlist_items.domain_name)'), Arel.sql('wishlist_items.updated_at'))
             .map { |domain, time| { domain_name: domain, age_days: age_in_days(time) } }
    end

    def view_signals
      return [] unless RecommendationEvent.table_exists?

      @view_signals ||=
        RecommendationEvent
        .joins(:auction)
        .where(user_id: @user.id, event_type: 'auction_detail_view')
        .pluck(Arel.sql('LOWER(auctions.domain_name)'), Arel.sql('recommendation_events.occurred_at'))
        .map { |domain, time| { domain_name: domain, age_days: age_in_days(time) } }
    end

    # ---------- Helpers --------------------------------------------------

    def auctions
      @auctions ||= @scope.to_a
    end

    def profile
      @profile ||= @user&.recommendation_profile
    end

    def decay_weight(age_days)
      return 1.0 if age_days.nil? || age_days <= 0

      Math.exp(-age_days.to_f / HALF_LIFE_DAYS)
    end

    def age_in_days(timestamp)
      return 0.0 if timestamp.nil?

      ((@calculated_at - timestamp).to_f / 1.day).clamp(0.0, Float::INFINITY)
    end
  end
end
