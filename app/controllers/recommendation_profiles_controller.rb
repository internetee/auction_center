class RecommendationProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_selection_enabled, only: %i[edit update]
  before_action :set_recommendation_profile

  def edit; end

  def update
    @recommendation_profile.assign_attributes(recommendation_profile_params)

    if !@recommendation_profile.filled?
      @recommendation_profile.dismiss_prompt!
      Recommendation::RefreshSingleUserAuctionScoresJob.enqueue_debounced(current_user.id)
      Recommendation::EventTracker.call(
        user: current_user,
        event_type: 'recommendation_prompt_dismissed',
        source: 'recommendation_profiles#update_blank',
        request:
      )

      redirect_to after_update_path, notice: t('.skipped')
      return
    end

    if @recommendation_profile.save
      @recommendation_profile.mark_completed!
      Recommendation::RefreshSingleUserAuctionScoresJob.enqueue_debounced(current_user.id)
      Recommendation::EventTracker.call(
        user: current_user,
        event_type: 'recommendation_profile_completed',
        source: 'recommendation_profiles#update',
        request:
      )

      redirect_to after_update_path, notice: t('.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def dismiss
    @recommendation_profile.dismiss_prompt!
    Recommendation::EventTracker.call(
      user: current_user,
      event_type: 'recommendation_prompt_dismissed',
      source: 'recommendation_profiles#dismiss',
      request:
    )

    redirect_to dismiss_redirect_path, notice: t('.dismissed')
  end

  private

  def ensure_selection_enabled
    return if RecommendationProfile.selection_enabled?

    redirect_to user_path(current_user.uuid)
  end

  def set_recommendation_profile
    @recommendation_profile = current_user.recommendation_profile || current_user.build_recommendation_profile
  end

  def recommendation_profile_params
    params.require(:recommendation_profile)
          .permit(
            :preferred_length_min,
            :preferred_length_max,
            :allow_numbers,
            :allow_hyphens,
            interest_categories: [],
            custom_interests: []
          )
  end

  def after_update_path
    requested_path = params[:return_to].to_s
    return requested_path if requested_path.starts_with?('/')

    user_path(current_user.uuid)
  end

  def dismiss_redirect_path
    requested_path = params[:return_to].to_s
    return requested_path if requested_path.starts_with?('/')

    root_path
  end
end
