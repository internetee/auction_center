module Admin
  class ResultsController < BaseController
    # GET /admin/results
    def index
      @results = Result.all.order(created_at: :desc)

      @auctions_needing_results = Auction.without_result
    end

    # POST /admin/results
    def create
      job = ResultCreationJob.perform_later

      if job
        redirect_to admin_results_path, notice: t(:job_enqueued)
      else
        render :index
      end
    end

    # GET /admin/results/1
    def show
      @result = Result.includes(:auction).find(params[:id])
      @offers = Offer.where(auction_id: @result.auction_id)
    end
  end
end
