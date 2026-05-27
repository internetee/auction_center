module Recommendation
  class Scorer
    SCORING_HORIZON = 30.days

    class << self
      BASELINE_MODEL_NAME = 'baseline_rules_v1'.freeze

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

      records = auctions.map { |auction| build_score_record(auction) }

      UserAuctionScore.upsert_all(records, unique_by: %i[user_id auction_id])
      records.size
    end

    private

    def build_score_record(auction)
      {
        user_id: @user.id,
        auction_id: auction.id,
        score: score_for(auction),
        model_name: self.class::BASELINE_MODEL_NAME,
        features_version: self.class::BASELINE_MODEL_NAME,
        calculated_at: @calculated_at,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    def score_for(auction)
      score = 0.0
      tags = Array(auction.classification_tags).map(&:to_s)
      domain_name = normalized_domain_name(auction.domain_name)

      score += 120 if wishlist_domains.include?(auction.domain_name.to_s.downcase)
      score += (matching_interest_tags(tags).size * 35)
      score += (matching_custom_interests(domain_name).size * 20)
      score += affinity_score(tags:, tag_counts: bid_tag_counts, weight: 8, cap: 24)
      score += affinity_score(tags:, tag_counts: wishlist_tag_counts, weight: 6, cap: 18)
      score += 15 if similar_to_saved_domain?(domain_name)
      score += 10 if within_preferred_length?(domain_name)
      score += digits_score(domain_name)
      score += hyphen_score(domain_name)
      score += ai_prior_score(auction)

      score.round(6)
    end

    def matching_interest_tags(tags)
      tags & rankable_interest_categories
    end

    def matching_custom_interests(domain_name)
      custom_interests.select do |interest|
        normalized_interest = normalized_domain_name(interest)
        normalized_interest.present? && domain_name.include?(normalized_interest)
      end
    end

    def affinity_score(tags:, tag_counts:, weight:, cap:)
      score = tags.sum { |tag| tag_counts[tag].to_i * weight }
      [score, cap].min
    end

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

    def bid_tag_counts
      @bid_tag_counts ||= build_tag_counts(
        Auction.joins(:offers).where(offers: { user_id: @user.id }).distinct.to_a
      )
    end

    def wishlist_tag_counts
      @wishlist_tag_counts ||= build_tag_counts(
        Auction.where(domain_name: @user.wishlist_items.select(:domain_name)).to_a
      )
    end

    def build_tag_counts(auctions)
      auctions.each_with_object(Hash.new(0)) do |auction, counts|
        Array(auction.classification_tags).each do |tag|
          counts[tag.to_s] += 1
        end
      end
    end

    def normalized_domain_name(value)
      value.to_s.downcase.sub(/\.ee\z/, '')
    end
  end
end
