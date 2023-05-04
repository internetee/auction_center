module ServiceWorkers
  class WorkersController < ApplicationController
    protect_from_forgery except: :index

    def index
      response.headers["Service-Worker-Allowed"] = "/"
      response.headers["Content-Type"] = "application/javascript"
      render layout: false
    end
  end
end
