class LocalesController < ApplicationController
  def update
    validate_locale

    if current_user
      current_user.update!(locale: permitted_locale)
    else
      cookies[:locale] = permitted_locale
    end

    redirect_back(fallback_location: root_path)
  end

  def permitted_locale
    params.require(:locale)
  end

  def validate_locale
    return if AuctionCenter::Application.config.i18n.available_locales.include?(permitted_locale)
  end
end
