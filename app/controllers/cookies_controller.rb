class CookiesController < ApplicationController
  def update
    session[:cookie_dialog] = 'accepted'
    session[:google_analytics] = if params[:cookies] == 'accepted' || params[:analytics_selected] == '1'
                                   'accepted'
                                 else
                                   'declined'
                                 end

    redirect_to root_path
  end
end
