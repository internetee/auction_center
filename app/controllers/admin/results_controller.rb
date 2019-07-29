module Admin
  class ResultsController < BaseController
    include OrderableHelper

    # GET /admin/results
    def index
      @results = Result.includes(:auction, :offer, :invoice, :user)
                       .all
                       .order(orderable_array)
                       .page(params[:page])

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

    # GET /admin/results/search
    def search
      domain_name = search_params[:domain_name]

      @results = Result.joins(:auction)
                       .includes(:offer, :invoice)
                       .where('auctions.domain_name ILIKE ?', "%#{domain_name}%")
                       .accessible_by(current_ability)
                       .order(orderable_array)
                       .page(1)
    end

    # GET /admin/results/1
    def show
      @result = Result.includes(:auction).find(params[:id])
      @offers = Offer.where(auction_id: @result.auction_id)
    end

    private

    def search_params
      search_params_copy = params.dup
      search_params_copy.permit(:domain_name)
    end
  end
end
