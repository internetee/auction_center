class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def set_locale
    I18n.locale = current_user&.locale || cookies[:locale] || I18n.default_locale
  end

  def current_user_for_updated_by
    return unless current_user

    "#{current_user.id} - #{current_user.display_name}"
  end
end
