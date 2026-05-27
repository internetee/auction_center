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
      auction = auctions(:valid_without_offers)
      UserAuctionScore.create!(
        user: @user,
        auction: auction,
        score: 1,
        calculated_at: 2.minutes.ago
      )

      assert_nothing_raised do
        Recommendation::RefreshSingleUserAuctionScoresJob.new.perform(@user.id)
      end

      reloaded = UserAuctionScore.where(user: @user).order(:calculated_at).last
      assert reloaded.calculated_at > 1.minute.ago, 'stale scores must be refreshed'
    end

    def test_perform_no_op_for_unknown_user
      assert_nothing_raised do
        Recommendation::RefreshSingleUserAuctionScoresJob.new.perform(-1)
      end
    end
  end
end
