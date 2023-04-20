module ServiceWorkers
  class ManifestsController < ApplicationController
    protect_from_forgery except: :index

    def index
      response.headers["Content-Type"] = "application/json"
      render layout: false
    end
  end
end
