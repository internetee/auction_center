module Admin
  class ResultsController < BaseController
    include OrderableHelper

    # GET /admin/results
    def index
      @results = Result.includes(:auction, offer: [:billing_profile])
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
      search_string = search_params[:domain_name]
      statuses_contains = params[:statuses_contains]

      @origin = search_string || search_params.dig(:order, :origin)
      @users = User.where("given_names ILIKE ? OR surname ILIKE ? OR email ILIKE ?", 
                          "%#{search_string}%", "%#{search_string}%", "%#{search_string}%").all
      @billing_profile = BillingProfile.where("name ILIKE ?", "%#{search_string}%").all
      user_ids = (@users.ids + [@billing_profile.select(:user_id)]).uniq

      @results = (Result.joins(:auction)
                      .includes(:offer, :invoice)
                      .where('auctions.domain_name ILIKE ?', "%#{@origin}%")
                      .accessible_by(current_ability)
                      .order(orderable_array) + Result.where(user_id: user_ids).page(1)).uniq
      return if statuses_contains.nil?
      @results = @results.select { |result| statuses_contains.include? result.status }
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
      search_params_copy.permit(:domain_name, :statuses_contains, order: :origin)
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
