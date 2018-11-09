module Admin
  class ResultsController < BaseController
    # GET /admin/results
    def index
      @results = Result.all.order(created_at: :desc)
    end

    # POST /admin/results
    def create

    end
  end
end
