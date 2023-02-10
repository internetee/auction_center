module Admin
  class PaidDepositsController < BaseController
    # GET /admin/results
    def index
      sort_column = params[:sort].presence_in(%w[users.email
                                                 created_at
                                                 auctions.requirement_deposit_in_cents
                                                 auctions.domain_name
                                                 status]) || 'created_at'
      sort_direction = params[:direction].presence_in(%w[asc desc]) || 'desc'

      deposits = DomainParticipateAuction.includes(:user)
                                         .includes(:auction)
                                         .search(params)
                                         .order("#{sort_column} #{sort_direction}")

      @pagy, @deposits = pagy(deposits, items: params[:per_page] ||= 15)
    end
  end
end
