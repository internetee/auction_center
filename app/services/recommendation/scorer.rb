module Recommendation
  # Recommendation::Scorer (v3, unified embedding space)
  # ----------------------------------------------------
  # Computes a per-user score for each active auction and upserts it into
  # user_auction_scores. Auction::UserSortable LEFT JOINs it to personalise the
  # /auctions index.
  #
  # v3 model (see docs/planning/recommendation-v3-unified-embedding-plan.md):
  # the ranking signal is *magnet pull* — everything about the user (bids,
  # wishlist, views, selected categories, custom interests) is embedded into one
  # vector space and the score is the mean of a candidate's two strongest pulls.
  # Recommendation::MagnetScorer owns that computation; this class scales it and
  # adds the structural nudges that similarity can't express (name shape + past
  # auction outcomes).
  #
  #   score = magnet_base * MAGNET_SCALE
  #         + length/digits/hyphen preference bonuses
  #         + result signal (lost similar auction ↑ / won ↓)
  #
  # No magnet or no candidate embedding → no row is written (and any stale row
  # is deleted), so the LEFT JOIN yields NULL and the domain falls to the
  # ai_score / RANDOM tail — exactly the "score IS NULL" branch in UserSortable.
  class Scorer
    HALF_LIFE_DAYS = MagnetScorer::HALF_LIFE_DAYS

    # Magnet pull is ~[-3, 3] (weight ≤3 × cosine ≤1, top-2 averaged). Scaling
    # it up lets similarity dominate the ordering while the structural bonuses
    # below (tens) act as secondary nudges. Tuning knob — see plan §3.4.
    MAGNET_SCALE = 100.0

    LENGTH_MATCH_BONUS = 10
    RESULT_LOST_BONUS = 25
    RESULT_WON_PENALTY = -5

    SCORER_NAME = 'unified_magnets_v3'.freeze
    FEATURES_VERSION = 'unified_v3'.freeze

    class << self
      def default_scope
        Auction.active
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
      records = auctions.filter_map { |auction| build_score_record(auction) }

      # Drop rows for candidates that no longer earn a score (magnet vanished,
      # embedding removed) so they correctly fall back to the tail.
      stale_ids = auctions.map(&:id) - records.map { |record| record[:auction_id] }
      UserAuctionScore.where(user_id: @user.id, auction_id: stale_ids).delete_all if stale_ids.any?

      UserAuctionScore.upsert_all(records, unique_by: %i[user_id auction_id]) if records.any?
      records.size
    end

    private

    # ---------- Per-auction scoring --------------------------------------

    def build_score_record(auction)
      value = score_for(auction)
      return nil if value.nil?

      {
        user_id: @user.id,
        auction_id: auction.id,
        score: value,
        scorer_name: SCORER_NAME,
        features_version: FEATURES_VERSION,
        calculated_at: @calculated_at,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    def score_for(auction)
      base = magnet_base[auction.id]
      return nil if base.nil?

      domain_name = normalized_domain_name(auction.domain_name)

      score = base * MAGNET_SCALE
      score += LENGTH_MATCH_BONUS if within_preferred_length?(domain_name)
      score += digits_score(domain_name)
      score += hyphen_score(domain_name)
      score += result_signal(tags_for(auction))
      score.round(6)
    end

    # ---------- Magnet base (delegated) ----------------------------------
    #
    # { auction_id => Float|nil }. MagnetScorer owns all embedding/behavioural
    # signal collection, so this class keeps only the structural layer.

    def magnet_base
      @magnet_base ||=
        MagnetScorer.new(user: @user, scope: @scope, calculated_at: @calculated_at).scores
    end

    # ---------- Classification preload (for result signal) ---------------

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
      (dc&.tags || Array(auction.classification_tags)).map(&:to_s).uniq
    end

    # ---------- Result signal --------------------------------------------
    #
    # If the user previously LOST an auction on a similar-tag domain, they're
    # still in the market — bump similar tags. If they WON, mild down-weight.

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
    end

    def lookup_user_results
      return [] unless Result.column_names.include?('winner_user_id')

      Result.where(winner_user_id: @user.id).to_a
    end

    def preload_result_classifications(results)
      domain_names = results.filter_map do |r|
        r.domain_name.to_s.downcase if r.respond_to?(:domain_name) && r.domain_name.present?
      end.uniq
      return {} if domain_names.empty?

      DomainClassification.where(domain_name: domain_names).index_by(&:domain_name)
    end

    # ---------- Structural (name shape) ----------------------------------

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

    # ---------- Helpers --------------------------------------------------

    def profile
      @profile ||= @user.recommendation_profile
    end

    def decay_weight(age_days)
      return 1.0 if age_days.nil? || age_days <= 0

      Math.exp(-age_days.to_f / HALF_LIFE_DAYS)
    end

    def age_in_days(timestamp)
      return 0.0 if timestamp.nil?

      ((@calculated_at - timestamp).to_f / 1.day).clamp(0.0, Float::INFINITY)
    end

    def normalized_domain_name(value)
      value.to_s.downcase.sub(/\.ee\z/, '')
    end
  end
end
