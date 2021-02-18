module Admin
  class ResultsController < BaseController
    include OrderableHelper

    # GET /admin/results
    def index
      @results = Result.includes(:auction, :offer, :invoice, :user)
                       .order(orderable_array(default_order_params))
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
      @origin = domain_name || search_params.dig(:order, :origin)

      @results = Result.joins(:auction)
                       .includes(:offer, :invoice)
                       .where('auctions.domain_name ILIKE ?', "%#{@origin}%")
                       .accessible_by(current_ability)
                       .order(orderable_array)
                       .page(1)
    end

    # GET /admin/results/1
    def show
      @result = Result.includes(:auction).find(params[:id])
      @offers = Offer.where(auction_id: @result.auction_id)

      return if @result.no_bids?

      @buyer = buyer_name
    end

    private

    def search_params
      search_params_copy = params.dup
      search_params_copy.permit(:domain_name, order: :origin)
    end

    def buyer_name
      return @result.offer.billing_profile.name if @result.offer.billing_profile.present?

      Invoice.find_by(result: @result.offer).recipient
    end

    def default_order_params
      { 'results.created_at' => 'desc' }
    end
  end
end
