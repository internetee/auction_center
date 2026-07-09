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

  def test_edit_form_renders_custom_interest_sentinel
    @user.create_recommendation_profile!(interest_keywords: %w[other custom:crypto])

    get edit_recommendation_profile_path

    assert_response :success
    # Without this sentinel, removing every custom-interest tag drops the param
    # entirely and the old free-text interests can never be cleared.
    assert_select "input[type=hidden][name='recommendation_profile[custom_interests][]'][value='']"
  end

  def test_clearing_all_custom_interests_removes_them
    @user.create_recommendation_profile!(interest_keywords: %w[legal other custom:crypto])

    # What the corrected form submits after the last custom tag is removed: the
    # sentinel-only empty param, with `other` still checked.
    put recommendation_profile_path, params: {
      recommendation_profile: {
        interest_categories: %w[legal other],
        custom_interests: ['']
      }
    }

    @user.reload
    assert_empty @user.recommendation_profile.custom_interests
    # `other` must not linger as an empty category once its custom interests are gone.
    assert_equal %w[legal], @user.recommendation_profile.interest_categories.sort
  end

  def test_user_can_dismiss_recommendation_prompt
    patch dismiss_recommendation_profile_path

    @user.reload

    assert_redirected_to root_path
    assert @user.recommendation_profile.prompt_dismissed_at.present?
  end

  def test_edit_redirects_when_selection_disabled
    settings(:recommendation_interests_enabled).update!(value: 'false')

    get edit_recommendation_profile_path

    assert_redirected_to user_path(@user.uuid)
  end

  def test_update_blocked_when_selection_disabled
    settings(:recommendation_interests_enabled).update!(value: 'false')

    assert_no_difference -> { RecommendationProfile.count } do
      put recommendation_profile_path, params: {
        recommendation_profile: { interest_categories: %w[legal] }
      }
    end

    assert_redirected_to user_path(@user.uuid)
  end
end
