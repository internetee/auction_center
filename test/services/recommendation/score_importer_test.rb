require 'test_helper'

module Recommendation
  class ScoreImporterTest < ActiveSupport::TestCase
    def setup
      super
      @user = users(:participant)
      @auction = auctions(:english)
    end

    def test_imports_scores_by_uuid
      imported_count = ScoreImporter.call(
        scores: [
          {
            user_uuid: @user.uuid,
            auction_uuid: @auction.uuid,
            score: 0.75
          }
        ],
        scorer_name: 'lightfm_stub',
        features_version: 'v1'
      )

      assert_equal 1, imported_count

      record = UserAuctionScore.find_by!(user: @user, auction: @auction)
      assert_equal BigDecimal('0.75'), record.score
      assert_equal 'lightfm_stub', record.scorer_name
      assert_equal 'v1', record.features_version
    end

    def test_upserts_existing_scores
      UserAuctionScore.create!(
        user: @user,
        auction: @auction,
        score: 0.10,
        calculated_at: 1.day.ago
      )

      ScoreImporter.call(
        scores: [
          {
            user_id: @user.id,
            auction_id: @auction.id,
            score: 0.90
          }
        ]
      )

      assert_equal 1, UserAuctionScore.where(user: @user, auction: @auction).count
      assert_equal BigDecimal('0.90'), UserAuctionScore.find_by!(user: @user, auction: @auction).score
    end
  end
end
