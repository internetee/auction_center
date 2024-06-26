class ApplicationController < ActionController::Base
  include Pagy::Backend

  # prepend_before_action :convert_punycode_params

  helper_method :turbo_frame_request?

  protect_from_forgery with: :exception
  before_action :set_locale, :clear_flash
  before_action :notifications_for_header

  content_security_policy do |policy|
    policy.style_src :self, 'www.gstatic.com', :unsafe_inline
  end

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:alert] = I18n.t('unauthorized.message')

    if turbo_frame_request?
      render turbo_stream: turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: })
    else
      redirect_to root_path
    end
  end

  def store_location
    return unless request.referer

    session[:return_to] = request.referer.split('?').first
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

  def after_sign_in_path_for(_resource) = root_path

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

  # def convert_punycode_params
  #   return unless email = request.params.dig(:user, :email)

  #   request.params[:user][:email] = email.split('@').map { |val| SimpleIDN.to_ascii(val) }.join('@')
  # end

  protected

  def authenticate_user!
    return if user_signed_in?

    sign_out @user

    flash[:alert] = t('devise.failure.unauthenticated')

    if turbo_frame_request?
      render turbo_stream: turbo_stream.action(:redirect, root_path)
    else
      redirect_to root_path
    end
  end
end
