module Recommendation
  # Recommendation::Scorer
  # ---------------------
  # Computes a per-user score for each active auction and upserts it
  # into user_auction_scores. Used by Auction::UserSortable to LEFT JOIN
  # personalised ordering onto the main /auctions index.
  #
  # Signal sources (all time-decayed where applicable):
  # - Explicit interests from recommendation_profile (tags + custom)
  # - Wishlist domains
  # - Bid history (Offer, EnglishOffer's Offer parent, DomainOfferHistory)
  # - Auction outcomes (Result) — lost auctions boost similar domains
  # - Detail-page views (RecommendationEvent auction_detail_view)
  # - Embedding-cosine similarity to user centroid (Phase 5+)
  #
  # Rich features (keywords, audience, embedding) come from
  # domain_classifications joined by domain_name. Legacy
  # auctions.classification_tags remains a fallback during migration.
  class Scorer
    SCORING_HORIZON = 30.days
    SIGNAL_LOOKBACK = 1.year
    HALF_LIFE_DAYS = 60.0

    WISHLIST_HIT = 120
    TAG_WEIGHT = 35
    KEYWORD_WEIGHT = 15
    AUDIENCE_MATCH = 10
    BID_AFFINITY_WEIGHT = 8
    BID_AFFINITY_CAP = 24
    WISHLIST_AFFINITY_WEIGHT = 6
    WISHLIST_AFFINITY_CAP = 18
    VIEW_AFFINITY_WEIGHT = 4
    VIEW_AFFINITY_CAP = 12
    SIMILAR_DOMAIN_BONUS = 15
    LENGTH_MATCH_BONUS = 10
    RESULT_LOST_BONUS = 25
    RESULT_WON_PENALTY = -5
    DOMAIN_OFFER_HISTORY_WEIGHT = 3
    DOMAIN_OFFER_HISTORY_CAP = 12

    BASELINE_MODEL_NAME = 'baseline_rules_v2'.freeze
    FEATURES_VERSION = 'rich_v1'.freeze

    class << self
      def default_scope
        Auction.active.where('ends_at <= ?', SCORING_HORIZON.from_now)
      end

      def top_auctions_for(user:, scope: default_scope, limit: nil)
        query = scope
          .joins(:user_auction_scores)
          .where(user_auction_scores: { user_id: user.id })
          .order('user_auction_scores.score DESC, auctions.ends_at ASC')

        limit ? query.limit(limit) : query
      end

      def refresh_for(user:, scope: default_scope, calculated_at: Time.current)
        new(user:, scope:, calculated_at:).refresh!
      end
    end

    def initialize(user:, scope: self.class.default_scope, calculated_at: Time.current)
      @user = user
      @scope = scope
      @calculated_at = calculated_at
    end

    def refresh!
      return 0 unless @user

      auctions = @scope.to_a
      return 0 if auctions.empty?

      preload_classifications(auctions)

      records = auctions.map { |auction| build_score_record(auction) }
      UserAuctionScore.upsert_all(records, unique_by: %i[user_id auction_id])
      records.size
    end

    private

    # ---------- Per-auction scoring --------------------------------------

    def build_score_record(auction)
      {
        user_id: @user.id,
        auction_id: auction.id,
        score: score_for(auction),
        model_name: BASELINE_MODEL_NAME,
        features_version: FEATURES_VERSION,
        calculated_at: @calculated_at,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    def score_for(auction)
      tags = tags_for(auction)
      keywords = keywords_for(auction)
      audience = audience_for(auction)
      domain_name = normalized_domain_name(auction.domain_name)

      score = 0.0

      # --- explicit signals ---
      score += WISHLIST_HIT if wishlist_domains.include?(auction.domain_name.to_s.downcase)
      score += matching_interest_tags(tags).size * TAG_WEIGHT
      score += matching_interest_keywords(keywords).size * KEYWORD_WEIGHT
      score += matching_custom_interests(domain_name).size * 20
      score += audience_match_bonus(audience)

      # --- behavioural affinity (time-decayed) ---
      score += affinity(tags: tags, keywords: keywords,
                        feature_counts: bid_feature_counts,
                        weight: BID_AFFINITY_WEIGHT, cap: BID_AFFINITY_CAP)
      score += affinity(tags: tags, keywords: keywords,
                        feature_counts: wishlist_feature_counts,
                        weight: WISHLIST_AFFINITY_WEIGHT, cap: WISHLIST_AFFINITY_CAP)
      score += affinity(tags: tags, keywords: keywords,
                        feature_counts: view_feature_counts,
                        weight: VIEW_AFFINITY_WEIGHT, cap: VIEW_AFFINITY_CAP)
      score += affinity(tags: tags, keywords: keywords,
                        feature_counts: domain_offer_history_feature_counts,
                        weight: DOMAIN_OFFER_HISTORY_WEIGHT,
                        cap: DOMAIN_OFFER_HISTORY_CAP)
      score += result_signal(tags)

      # --- structural ---
      score += SIMILAR_DOMAIN_BONUS if similar_to_saved_domain?(domain_name)
      score += LENGTH_MATCH_BONUS if within_preferred_length?(domain_name)
      score += digits_score(domain_name)
      score += hyphen_score(domain_name)
      score += ai_prior_score(auction)

      score *= embedding_multiplier(auction)
      score.round(6)
    end

    # ---------- Classification preload -----------------------------------

    def preload_classifications(auctions)
      domain_names = auctions.map { |a| a.domain_name.to_s.downcase }.uniq
      @classifications_by_domain =
        DomainClassification
          .where(domain_name: domain_names)
          .index_by { |dc| dc.domain_name.to_s.downcase }
    end

    def classification_for(auction)
      return nil unless defined?(@classifications_by_domain)

      @classifications_by_domain[auction.domain_name.to_s.downcase]
    end

    def tags_for(auction)
      dc = classification_for(auction)
      tags = (dc&.tags || Array(auction.classification_tags)).map(&:to_s)
      tags.uniq
    end

    def keywords_for(auction)
      Array(classification_for(auction)&.keywords).map(&:to_s).uniq
    end

    def audience_for(auction)
      classification_for(auction)&.audience
    end

    def embedding_for(auction)
      dc = classification_for(auction)
      return nil unless dc&.respond_to?(:embedding)

      dc.embedding
    end

    # ---------- Matchers --------------------------------------------------

    def matching_interest_tags(tags)
      tags & rankable_interest_categories
    end

    def matching_interest_keywords(keywords)
      return [] if keywords.blank?

      interest_keyword_pool & keywords
    end

    def interest_keyword_pool
      @interest_keyword_pool ||= (rankable_interest_categories + custom_interests).map(&:to_s).map(&:downcase)
    end

    def matching_custom_interests(domain_name)
      custom_interests.select do |interest|
        normalized_interest = normalized_domain_name(interest)
        normalized_interest.present? && domain_name.include?(normalized_interest)
      end
    end

    # Audience match (b2b/b2c) is captured for every classified domain
    # but RecommendationProfile does not yet expose a user-side
    # audience_preference column. Until it does, derive a soft signal:
    # if the user's bid history skews toward one audience, boost
    # candidates with the same audience. Falls back to 0.
    def audience_match_bonus(audience)
      return 0 if audience.blank?
      return 0 if dominant_user_audience.blank?
      return AUDIENCE_MATCH if dominant_user_audience == audience

      0
    end

    def dominant_user_audience
      return @dominant_user_audience if defined?(@dominant_user_audience)

      counts = Hash.new(0)
      (bid_domain_signals + wishlist_domain_signals).each do |signal|
        dc = bid_wishlist_classification_cache[signal[:domain_name]]
        counts[dc.audience] += 1 if dc&.audience.present?
      end

      @dominant_user_audience = counts.max_by { |_, n| n }&.first
    end

    def bid_wishlist_classification_cache
      @bid_wishlist_classification_cache ||= begin
        names = (bid_domain_signals + wishlist_domain_signals).map { |s| s[:domain_name] }.uniq
        DomainClassification.where(domain_name: names).index_by(&:domain_name)
      end
    end

    # ---------- Behavioural affinity -------------------------------------

    def affinity(tags:, keywords:, feature_counts:, weight:, cap:)
      return 0 if feature_counts.blank?

      tag_score = tags.sum { |tag| feature_counts[:tags][tag.to_s].to_f * weight }
      keyword_score = keywords.sum { |kw| feature_counts[:keywords][kw.to_s].to_f * (weight / 2.0) }
      [tag_score + keyword_score, cap].min
    end

    def bid_feature_counts
      @bid_feature_counts ||= aggregate_features(bid_domain_signals)
    end

    def wishlist_feature_counts
      @wishlist_feature_counts ||= aggregate_features(wishlist_domain_signals)
    end

    def view_feature_counts
      @view_feature_counts ||= aggregate_features(view_domain_signals)
    end

    def domain_offer_history_feature_counts
      @domain_offer_history_feature_counts ||= aggregate_features(domain_offer_history_signals)
    end

    # ---------- Signal collection ----------------------------------------
    #
    # Each method returns an array of {domain_name:, age_days:} pairs.

    # All signal queries skip an explicit time WHERE because time decay
    # (HALF_LIFE_DAYS=60) makes events older than a few half-lives
    # mathematically negligible. Filtering in SQL adds risk of dropping
    # fixtures with travel_to and provides minimal performance benefit
    # at our scale.

    def bid_domain_signals
      Offer
        .joins(:auction)
        .where(user_id: @user.id)
        .pluck('LOWER(auctions.domain_name)', 'offers.updated_at')
        .map { |domain, time| { domain_name: domain, age_days: age_in_days(time) } }
    end

    def wishlist_domain_signals
      @user.wishlist_items
           .pluck('LOWER(wishlist_items.domain_name)', 'wishlist_items.updated_at')
           .map { |domain, time| { domain_name: domain, age_days: age_in_days(time) } }
    end

    def view_domain_signals
      return [] unless RecommendationEvent.table_exists?

      RecommendationEvent
        .joins(:auction)
        .where(user_id: @user.id, event_type: 'auction_detail_view')
        .pluck('LOWER(auctions.domain_name)', 'recommendation_events.occurred_at')
        .map { |domain, time| { domain_name: domain, age_days: age_in_days(time) } }
    end

    def domain_offer_history_signals
      return [] unless defined?(DomainOfferHistory) && DomainOfferHistory.table_exists?
      return [] unless DomainOfferHistory.column_names.include?('user_id')

      DomainOfferHistory
        .where(user_id: @user.id)
        .pluck('LOWER(domain_name)', 'domain_offer_histories.updated_at')
        .map { |domain, time| { domain_name: domain, age_days: age_in_days(time) } }
    rescue StandardError
      []
    end

    def aggregate_features(signals)
      return { tags: {}, keywords: {} } if signals.empty?

      domain_names = signals.map { |s| s[:domain_name] }.uniq
      classifications = DomainClassification.where(domain_name: domain_names).index_by(&:domain_name)

      # Fallback: if domain_classifications is missing a domain we have
      # behavioural data for (legacy auctions classified pre-v2), pull
      # the tags directly from auctions.classification_tags so the signal
      # is not dropped.
      missing_domains = domain_names - classifications.keys
      auction_fallback_tags = fallback_tags_for(missing_domains)

      tags = Hash.new(0.0)
      keywords = Hash.new(0.0)

      signals.each do |signal|
        decay = decay_weight(signal[:age_days])
        dc = classifications[signal[:domain_name]]

        if dc
          Array(dc.tags).each    { |t| tags[t.to_s] += decay }
          Array(dc.keywords).each { |k| keywords[k.to_s] += decay }
        elsif (fallback = auction_fallback_tags[signal[:domain_name]])
          fallback.each { |t| tags[t.to_s] += decay }
        end
      end

      { tags: tags, keywords: keywords }
    end

    def fallback_tags_for(domain_names)
      return {} if domain_names.empty?

      Auction
        .where('LOWER(domain_name) IN (?)', domain_names)
        .pluck(Arel.sql('LOWER(domain_name)'), :classification_tags)
        .each_with_object({}) do |(name, tag_list), acc|
          next if tag_list.blank?

          acc[name] ||= []
          acc[name].concat(Array(tag_list))
          acc[name].uniq!
        end
    end

    def decay_weight(age_days)
      return 1.0 if age_days.nil? || age_days <= 0

      Math.exp(-age_days.to_f / HALF_LIFE_DAYS)
    end

    def age_in_days(timestamp)
      return 0.0 if timestamp.nil?

      ((@calculated_at - timestamp).to_f / 1.day).clamp(0.0, Float::INFINITY)
    end

    # ---------- Result signal -------------------------------------------
    #
    # If the user previously LOST an auction on a similar-tag domain,
    # they're still in the market — bump similar tags. If they WON,
    # mild down-weight (they already got that domain).

    def result_signal(tags)
      return 0 if tags.empty? || result_signal_by_tag.empty?

      tags.sum { |tag| result_signal_by_tag[tag.to_s].to_f }
    end

    def result_signal_by_tag
      @result_signal_by_tag ||= compute_result_signal
    end

    def compute_result_signal
      return {} unless defined?(Result) && Result.table_exists?

      results = lookup_user_results
      return {} if results.blank?

      classifications = preload_result_classifications(results)
      signals = Hash.new(0.0)

      results.each do |result|
        domain = result.respond_to?(:domain_name) ? result.domain_name.to_s.downcase : nil
        next if domain.blank?

        dc = classifications[domain]
        next if dc.nil?

        won = result.respond_to?(:winner_user_id) && result.winner_user_id == @user.id
        decay = decay_weight(age_in_days(result.updated_at))
        bonus = won ? RESULT_WON_PENALTY : RESULT_LOST_BONUS

        Array(dc.tags).each { |tag| signals[tag.to_s] += bonus * decay }
      end

      signals
    rescue StandardError
      {}
    end

    def lookup_user_results
      return [] unless Result.column_names.include?('winner_user_id')

      Result.where(winner_user_id: @user.id).to_a
    rescue StandardError
      []
    end

    def preload_result_classifications(results)
      domain_names = results.filter_map do |r|
        r.domain_name.to_s.downcase if r.respond_to?(:domain_name) && r.domain_name.present?
      end.uniq
      return {} if domain_names.empty?

      DomainClassification.where(domain_name: domain_names).index_by(&:domain_name)
    end

    # ---------- Embedding multiplier ------------------------------------

    def embedding_multiplier(auction)
      return 1.0 unless DomainClassification.column_names.include?('embedding')
      return 1.0 if user_embedding_centroid.nil?

      auction_embedding = embedding_for(auction)
      return 1.0 if auction_embedding.nil?

      similarity = cosine_similarity(user_embedding_centroid, auction_embedding)
      return 1.0 if similarity.nil?

      1.0 + [similarity, 0.0].max
    end

    def user_embedding_centroid
      return @user_embedding_centroid if defined?(@user_embedding_centroid)

      @user_embedding_centroid = compute_user_centroid
    end

    def compute_user_centroid
      return nil unless DomainClassification.column_names.include?('embedding')

      signals = bid_domain_signals + wishlist_domain_signals + view_domain_signals
      return nil if signals.empty?

      domain_names = signals.map { |s| s[:domain_name] }.uniq
      embeddings = DomainClassification
                     .where(domain_name: domain_names)
                     .where.not(embedding: nil)
                     .index_by(&:domain_name)
      return nil if embeddings.empty?

      sum = Array.new(DomainClassification::EMBEDDING_DIMENSIONS, 0.0)
      total_weight = 0.0

      signals.each do |signal|
        dc = embeddings[signal[:domain_name]]
        next unless dc&.embedding

        weight = decay_weight(signal[:age_days])
        vector = embedding_as_array(dc.embedding)
        next if vector.nil? || vector.size != sum.size

        vector.each_with_index { |v, i| sum[i] += v * weight }
        total_weight += weight
      end

      return nil if total_weight.zero?

      sum.map { |v| v / total_weight }
    end

    def cosine_similarity(a, b)
      vec_b = embedding_as_array(b)
      return nil if a.nil? || vec_b.nil? || a.size != vec_b.size

      dot = 0.0
      norm_a = 0.0
      norm_b = 0.0
      a.each_with_index do |val, i|
        dot += val * vec_b[i]
        norm_a += val * val
        norm_b += vec_b[i] * vec_b[i]
      end

      denom = Math.sqrt(norm_a) * Math.sqrt(norm_b)
      return nil if denom.zero?

      dot / denom
    end

    def embedding_as_array(embedding)
      return embedding if embedding.is_a?(Array)
      return embedding.to_a if embedding.respond_to?(:to_a)

      nil
    rescue StandardError
      nil
    end

    # ---------- Structural ----------------------------------------------

    def similar_to_saved_domain?(domain_name)
      saved_domain_roots.any? do |saved_root|
        saved_root.present? && (domain_name.include?(saved_root) || saved_root.include?(domain_name))
      end
    end

    def within_preferred_length?(domain_name)
      return false unless profile

      length = domain_name.length
      return false if profile.preferred_length_min.present? && length < profile.preferred_length_min
      return false if profile.preferred_length_max.present? && length > profile.preferred_length_max

      profile.preferred_length_min.present? || profile.preferred_length_max.present?
    end

    def digits_score(domain_name)
      return 0 unless domain_name.match?(/\d/)

      if profile&.allow_numbers == false
        -20
      elsif profile&.allow_numbers == true
        8
      else
        0
      end
    end

    def hyphen_score(domain_name)
      return 0 unless domain_name.include?('-')

      if profile&.allow_hyphens == false
        -12
      elsif profile&.allow_hyphens == true
        5
      else
        0
      end
    end

    def ai_prior_score(auction)
      auction.ai_score.to_f / 10.0
    end

    # ---------- Profile / wishlist memoisers ----------------------------

    def profile
      @profile ||= @user.recommendation_profile
    end

    def rankable_interest_categories
      @rankable_interest_categories ||= Array(profile&.rankable_interest_categories).map(&:to_s)
    end

    def custom_interests
      @custom_interests ||= Array(profile&.custom_interests).map(&:to_s)
    end

    def wishlist_domains
      @wishlist_domains ||= @user.wishlist_items.pluck(:domain_name).map(&:downcase)
    end

    def saved_domain_roots
      @saved_domain_roots ||= wishlist_domains.map { |domain| normalized_domain_name(domain) }.uniq
    end

    def normalized_domain_name(value)
      value.to_s.downcase.sub(/\.ee\z/, '')
    end
  end
end
