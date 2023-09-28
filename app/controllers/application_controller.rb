class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :turbo_frame_request?

  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :set_notifications

  content_security_policy do |policy|
    policy.style_src :self, 'www.gstatic.com', :unsafe_inline
  end

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:alert] = I18n.t('unauthorized.message')
    # redirect_to root_url
    render turbo_stream: turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: flash })
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

  def after_sign_in_path_for(_resource)
    root_path
  end

  def set_notifications
    # don't change the name, it's used in the header and can be conflict with notification variable in notifications page
    @notifications_for_header = current_user&.notifications&.unread&.order(created_at: :desc)&.limit(5)
  end
end
