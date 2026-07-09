require 'test_helper'

module Recommendation
  class RefreshSingleUserAuctionScoresJobTest < ActiveJob::TestCase
    def setup
      super
      @user = users(:participant)
    end

    def test_enqueue_debounced_schedules_job
      assert_enqueued_with(
        job: Recommendation::RefreshSingleUserAuctionScoresJob,
        args: [@user.id]
      ) do
        Recommendation::RefreshSingleUserAuctionScoresJob.enqueue_debounced(@user.id)
      end
    end

    def test_perform_skips_when_user_has_fresh_scores
      auction = auctions(:valid_without_offers)
      UserAuctionScore.create!(
        user: @user,
        auction: auction,
        score: 10,
        calculated_at: 5.seconds.ago
      )

      max_updated_at_before = UserAuctionScore.where(user: @user).maximum(:updated_at)

      Recommendation::RefreshSingleUserAuctionScoresJob.new.perform(@user.id)

      max_updated_at_after = UserAuctionScore.where(user: @user).maximum(:updated_at)

      assert_equal max_updated_at_before, max_updated_at_after,
                   'job must not touch fresh user_auction_scores'
    end

    def test_perform_refreshes_when_scores_are_stale
      skip 'embedding column missing' unless DomainClassification.column_names.include?('embedding')

      # v3: a score row only survives a refresh when the candidate earns a magnet
      # pull, so give the user one signal and the candidate a matching embedding.
      give_user_a_magnet
      domain = "stale-refresh-#{SecureRandom.hex(4)}.ee"
      auction = Auction.create!(
        domain_name: domain,
        starts_at: 1.hour.ago,
        ends_at: 1.day.from_now,
        skip_validation: true
      )
      classify(domain, Array.new(8, 1.0))
      UserAuctionScore.create!(
        user: @user,
        auction: auction,
        score: 1,
        calculated_at: 2.minutes.ago
      )

      assert_nothing_raised do
        Recommendation::RefreshSingleUserAuctionScoresJob.new.perform(@user.id)
      end

      reloaded = UserAuctionScore.find_by!(user: @user, auction: auction)
      assert reloaded.calculated_at > 1.minute.ago, 'stale scores must be refreshed'
    end

    def test_perform_reenqueues_when_recently_refreshed
      auction = auctions(:valid_without_offers)
      UserAuctionScore.create!(
        user: @user,
        auction: auction,
        score: 10,
        calculated_at: 5.seconds.ago
      )

      assert_enqueued_with(
        job: Recommendation::RefreshSingleUserAuctionScoresJob,
        args: [@user.id]
      ) do
        Recommendation::RefreshSingleUserAuctionScoresJob.new.perform(@user.id)
      end
    end

    def test_perform_no_op_for_unknown_user
      assert_nothing_raised do
        Recommendation::RefreshSingleUserAuctionScoresJob.new.perform(-1)
      end
    end

    private

    def give_user_a_magnet
      history = Auction.create!(
        domain_name: "history-#{SecureRandom.hex(4)}.ee",
        starts_at: 2.days.ago, ends_at: 1.day.ago, skip_validation: true
      )
      Offer.new(user: @user, auction: history, cents: 100,
                billing_profile: billing_profiles(:private_person)).save(validate: false)
      classify(history.domain_name, Array.new(8, 1.0))
    end

    def classify(domain_name, embedding)
      DomainClassification.create!(
        domain_name: domain_name, primary_category: 'saas', tags: %w[saas], keywords: %w[cloud],
        embedding: embedding, classified_at: 1.hour.ago, confidence: 0.9
      )
    end
  end
end
