require 'test_helper'

class RecommendationProfilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  def setup
    super
    @user = users(:participant)
    sign_in @user
    clear_enqueued_jobs
  end

  def test_user_can_update_recommendation_profile
    assert_nil @user.recommendation_profile

    assert_difference -> { RecommendationProfile.count } do
      assert_enqueued_with(job: Recommendation::RefreshSingleUserAuctionScoresJob, args: [@user.id]) do
        put recommendation_profile_path, params: {
          recommendation_profile: {
            interest_categories: %w[legal other],
            custom_interests: ['marketplace']
          }
        }
      end
    end

    @user.reload

    assert_redirected_to user_path(@user.uuid)
    assert_equal(%w[legal other], @user.recommendation_profile.interest_categories.sort)
    assert_equal(['marketplace'], @user.recommendation_profile.custom_interests)
    assert @user.recommendation_profile.completed?
  end

  def test_user_can_dismiss_recommendation_prompt
    patch dismiss_recommendation_profile_path

    @user.reload

    assert_redirected_to root_path
    assert @user.recommendation_profile.prompt_dismissed_at.present?
  end
end
