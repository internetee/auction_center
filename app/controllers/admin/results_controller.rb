module Admin
  class ResultsController < BaseController
    # GET /admin/results
    def index
      @results = result_query.order(sort_params)
      @pagy, @results = pagy(@results, items: params[:per_page] ||= 15, link_extra: 'data-turbo-action="advance"')

      @auctions_needing_results = Auction.without_result.search(params)
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

      return if @result.no_bids?

      @buyer = buyer_name
    end

    private

    def sort_params
      { allowed_sort_columns[sort_column] => allowed_sort_directions }
    end

    def result_query = Result.includes(:auction, offer: [:billing_profile])
                             .references(:auction, :offer)
                             .search(params)
                             .includes(:user)

    def sort_column = params[:sort_by].presence_in(allowed_sort_columns.keys) || 'auctions.ends_at'

    def allowed_sort_directions = params[:sort_direction].presence_in(%w[asc desc]) || 'desc'

    def allowed_sort_columns = {
      'auctions.domain_name' => 'auctions.domain_name',
      'auctions.ends_at' => 'auctions.ends_at',
      'results.registration_due_date' => 'results.registration_due_date',
      'status' => 'results.status',
      'billing_profile_id' => 'offers.billing_profile_id'
    }

    def buyer_name
      return @result.offer.billing_profile.name if @result.offer.billing_profile.present?

      Invoice.find_by(result: @result.offer).recipient
    end
  end
end
