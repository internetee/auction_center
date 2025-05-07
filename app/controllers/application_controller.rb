class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :turbo_frame_request?

  protect_from_forgery with: :exception
  before_action :clear_flash, :store_user_location!, if: :storable_location?
  before_action :set_locale
  before_action :notifications_for_header

  content_security_policy do |policy|
    policy.style_src :self, 'www.gstatic.com', :unsafe_inline
  end

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:alert] = if current_user.banned?
                      I18n.t('unauthorized.banned.message')
                    else
                      I18n.t('unauthorized.message')
                    end

    if turbo_frame_request?
      render turbo_stream: turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: })
    else
      redirect_to root_path
    end
  end

  rescue_from ActionController::UnknownFormat do |_exception|
    head :not_acceptable
  end

  def store_location
    session[:return_to] = if request.get?
                            request.fullpath
                          else
                            request.referer
                          end
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

  def after_sign_in_path_for(resource_or_scope)
    request.env['omniauth.origin'] || stored_location_for(resource_or_scope) || root_path
  end

  def notifications_for_header
    # don't change the name, it's used in the header and can be conflict with notification variable in notifications page
    @notifications_for_header ||= current_user&.notifications&.unread&.order(created_at: :desc)&.limit(5)
  end

  private

  def set_locale
    set_locale_to_cookies

    I18n.locale = current_user&.locale || cookies[:locale] || I18n.default_locale
    @pagy_locale = I18n.locale.to_s
  end

  def set_locale_to_cookies
    return unless params[:localize].present? && I18n.available_locales.include?(params[:localize].to_sym)

    cookies[:locale] = params[:localize]
  end

  def clear_flash
    flash.clear if turbo_frame_request?
  end

  protected

  def authenticate_user!
    return if user_signed_in?

    store_location_for(:user, request.fullpath) if request.get? || request.head?
    store_location_for(:user, request.referer) unless request.get? || request.head?

    sign_out @user

    flash[:alert] = t('devise.failure.unauthenticated')

    if turbo_frame_request?
      render turbo_stream: turbo_stream.action(:redirect, root_path)
    else
      redirect_to new_user_session_path
    end
  end

  def storable_location?
    request.get? && is_navigational_format? &&
      !devise_controller? &&
      !request.xhr? &&
      !request.path.starts_with?('/auth/')
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
