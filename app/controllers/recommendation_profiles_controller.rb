class RecommendationProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_selection_enabled, only: %i[edit update]
  before_action :set_recommendation_profile

  def edit; end

  def update
    @recommendation_profile.assign_attributes(recommendation_profile_params)

    unless @recommendation_profile.filled?
      @recommendation_profile.skip!(source: 'recommendation_profiles#update_blank', request:)
      redirect_to after_update_path, notice: t('.skipped')
      return
    end

    if @recommendation_profile.save
      @recommendation_profile.complete!(source: 'recommendation_profiles#update', request:)
      redirect_to after_update_path, notice: t('.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def dismiss
    @recommendation_profile.dismiss!(source: 'recommendation_profiles#dismiss', request:)
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

  # Local paths only: rejects javascript:, absolute URLs, //host, /\host and control chars
  # (browsers drop tabs/newlines, so "/\t/host" becomes "//host").
  def return_path
    path = params[:return_to].to_s
    path if path.start_with?('/') && !path.start_with?('//', '/\\') && !path.match?(/[[:cntrl:]]/)
  end
  helper_method :return_path

  def after_update_path = return_path || user_path(current_user.uuid)

  def dismiss_redirect_path = return_path || root_path
end
