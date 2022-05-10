module Admin
  class ResultsController < BaseController
    include OrderableHelper

    # GET /admin/results
    def index
      @results = Result.includes(:auction, offer: [:billing_profile])
                       .search(params)
                       .order(orderable_array(default_order_params))
                       .page(params[:page])

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

    # GET /admin/results/search
    def search
      search_string = search_params[:domain_name]
      statuses_contains = params[:statuses_contains]

      @origin = search_string || search_params.dig(:order, :origin)
      @results = return_search_results(search_string)

      return if statuses_contains.nil?

      statuses_filter(statuses_contains)
    end

    # GET /admin/results/1
    def show
      @result = Result.includes(:auction).find(params[:id])
      @offers = Offer.where(auction_id: @result.auction_id)

      return if @result.no_bids?

      @buyer = buyer_name
    end

    private

    def return_search_results(search_string)
      user_ids = return_uniq_user_ids(search_string)
      (search_domain_names_result + search_by_users_ids(user_ids)).uniq
    end

    def return_uniq_user_ids(search_string)
      users = find_users(search_string)
      billing_profile_user_ids = find_users_from_billing_profile(search_string)
      (users.ids + [billing_profile_user_ids]).uniq
    end

    def find_users_from_billing_profile(search_string)
      billing_profile = BillingProfile.where('name ILIKE ?', "%#{search_string}%").all
      billing_profile.select(:user_id)
    end

    def find_users(search_string)
      User.where('given_names ILIKE ? OR surname ILIKE ? OR email ILIKE ?',
                 "%#{search_string}%", "%#{search_string}%", "%#{search_string}%").all
    end

    def statuses_filter(statuses)
      @results = @results.select { |result| statuses.include? result.status }
    end

    def search_by_users_ids(user_ids)
      Result.where(user_id: user_ids).page(1)
    end

    def search_domain_names_result
      Result.joins(:auction)
            .includes(:offer, :invoice)
            .where('auctions.domain_name ILIKE ?', "%#{@origin}%")
            .accessible_by(current_ability)
            .order(orderable_array)
    end

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
