module Admin
  class ResultsController < BaseController
    # GET /admin/results
    def index
      @results = Result.all.order(created_at: :desc)
      @auctions_needing_results = Auction.without_result
    end

    # POST /admin/results
    def create; end
  end
end
