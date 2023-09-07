class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :turbo_frame_request?

  protect_from_forgery with: :exception
  before_action :set_locale

  content_security_policy do |policy|
    policy.style_src :self, 'www.gstatic.com', :unsafe_inline
  end

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:alert] = I18n.t('unauthorized.message')
    redirect_to root_url
  end

  def set_locale
    if params[:localize].present? && I18n.available_locales.include?(params[:localize].to_sym)
      cookies[:locale] = params[:localize]
    end

    I18n.locale = current_user&.locale || cookies[:locale] || I18n.default_locale
    @pagy_locale = I18n.locale.to_s
  end

  def store_location
    session[:return_to] = request.referer.split('?').first if request.referer
  end

  # If needed, add updated_by to the params hash. Updated by takes format of "123 - User Surname"
  # When no current user is set, return back the hash as is.
  def merge_updated_by(update_params)
    if current_user
      user_string = "#{current_user.id} - #{current_user.display_name}"
      update_params.merge(updated_by: user_string)
    else
      update_params
    end
  end
end
