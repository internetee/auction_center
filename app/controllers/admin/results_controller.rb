module Admin
  class ResultsController < BaseController
    include OrderableHelper

    # GET /admin/results
    def index
      sort_column = params[:sort].presence_in(%w{ auctions.domain_name
                                                  auctions.ends_at
                                                  registration_due_date
                                                  status
                                                  users.id }) || "auctions.ends_at"
      sort_direction = params[:direction].presence_in(%w{ asc desc }) || "desc"

      @results = Result.includes(:auction, offer: [:billing_profile])
                       .search(params)
                       .includes(:user)
                       .includes(:auction)
                       .order("#{sort_column} #{sort_direction}")

      @pagy, @results = pagy(@results, items: params[:per_page] ||= 15)

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

    def buyer_name
      return @result.offer.billing_profile.name if @result.offer.billing_profile.present?

      Invoice.find_by(result: @result.offer).recipient
    end
  end
end
