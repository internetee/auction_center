class CookiesController < ApplicationController
  def update
    cookies[:cookie_dialog] = {
      value: "accepted",
      expires: 1.year.from_now,
    }

    cookies[:google_analytics] = if params[:cookies] == 'accepted' || params[:analytics_selected] == '1'
                                    {
                                      value: "accepted",
                                      expires: 1.year.from_now,
                                    }
                                  else
                                    {
                                      value: "declined",
                                      expires: 1.year.from_now,
                                    }
                                  end
    
    redirect_to root_path
  end
end
