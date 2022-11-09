module Admin
  class AuctionsController < BaseController
    before_action :authorize_user
    before_action :set_auction, only: %i[show destroy]
    before_action :validate_enable_and_disable_option_in_same_action, only: %i[bulk_starts_at]

    # GET /admin/auctions/new
    def new
      @auction = Auction.new
    end

    # POST /admin/auctions
    def create
      @auction = Auction.new(create_params)

      respond_to do |format|
        if @auction.save
          format.html { redirect_to admin_auction_path(@auction), notice: t(:created) }
          format.json { render :show, status: :created, location: @auction }
        else
          format.html { render :new }
          format.json { render json: @auction.errors, status: :unprocessable_entity }
        end
      end
    end

    # GET /admin/auctions
    def index
      sort_column = params[:sort].presence_in(%w[domain name
                                                 starts_at
                                                 ends_at
                                                 highest_offer_cents
                                                 number_of_offers
                                                 turns_count
                                                 starting_price
                                                 min_bids_step
                                                 slipping_end
                                                 platform]) || 'id'
      sort_direction = params[:direction].presence_in(%w[asc desc]) || 'desc'

      collection_one = Auction.where.not('ends_at <= ?', Time.zone.now).pluck(:id)
      collection_two = Auction.where(starts_at: nil).pluck(:id)
      collection = Auction.where(id: collection_one + collection_two).search(params).order(sort_column => sort_direction)

      @pagy, @auctions = pagy(collection, items: params[:per_page] ||= 20, link_extra: 'data-turbo-action="advance"')
    end

    # GET /admin/auctions/1
    def show
      @offers = @auction.offers.order(cents: :desc)
      users = User.search_deposit_participants(params)
      @pagy, @users = pagy(users, items: params[:per_page] ||= 20, link_extra: 'data-turbo-action="advance"')
    end

    # DELETE /admin/auctions/1
    def destroy
      respond_to do |format|
        if @auction.can_be_deleted?
          @auction.destroy
          format.html { redirect_to admin_auctions_path, notice: t(:deleted) }
          format.json { head :no_content }
        else
          format.html { redirect_to admin_auctions_path, notice: t('.cannot_delete') }
          format.json { render json: { errors: [t('.cannot_delete')] }, status: :forbidden }
        end
      end
    end

    def bulk_starts_at
      skipped_auctions = AdminBulkActionService.apply_for_english_auction(auction_elements: params[:auction_elements])

      flash[:notice] = "These auctions were skipped: #{skipped_auctions.join(' ')}"
      flash[:notice] = 'New value was set' if skipped_auctions.empty?

      redirect_to admin_auctions_path
    end

    def apply_auction_participants
      auction = Auction.find_by_uuid(params[:auction_uuid])
      users = User.where(id: params[:user_ids])
      users.each do |user|
        DomainParticipateAuction.create!(user: user, auction: auction)
      end

      redirect_to admin_auction_path(auction)
    end

    private

    def validate_enable_and_disable_option_in_same_action
      auction_elements = params[:auction_elements]

      if auction_elements[:enable_deposit] == 'true' &&
         auction_elements[:disable_deposit] == 'true'

        flash[:alert] = 'it cannot be enable and disable deposit in same action'
        redirect_to admin_auctions_path and return
      end
    end

    def create_params
      params.require(:auction).permit(:domain_name, :starts_at, :ends_at)
    end

    def authorize_user
      authorize! :manage, Auction
    end

    def set_auction
      @auction = Auction.find(params[:id])
    end
  end
end
