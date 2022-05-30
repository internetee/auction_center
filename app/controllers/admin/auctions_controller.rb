module Admin
  class AuctionsController < BaseController
    before_action :authorize_user
    before_action :set_auction, only: %i[show destroy]

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
      sort_column = params[:sort].presence_in(%w{ domain name 
                                                  starts_at
                                                  ends_at
                                                  highest_offer_cents
                                                  number_of_offers
                                                  turns_count
                                                  starting_price
                                                  min_bids_step
                                                  slipping_end
                                                  platform}) || "id"
      sort_direction = params[:direction].presence_in(%w{ asc desc }) || "desc"

      collection_one = Auction.where.not('ends_at <= ?', Time.zone.now).pluck(:id)
      collection_two = Auction.where(starts_at: nil).pluck(:id)
      collection = Auction.where(id: collection_one + collection_two).search(params).order(sort_column => sort_direction)

      @pagy, @auctions = pagy(collection, items: params[:per_page] ||= 20, link_extra: 'data-turbo-action="advance"')
    end

    # GET /admin/auctions/1
    def show
      @offers = @auction.offers.order(cents: :desc)
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
      auctions_data = params[:auction_elements]

      auction_ids = auctions_data[:auction_ids]
      auction_ids = auctions_data[:elements_id].split(' ') if auction_ids.nil?

      return if auction_ids.nil?

      @auctions = Auction.where(id: auction_ids)

      skipped_auctions = []

      @auctions.each do |auction|
        if !auction.starts_at.nil? && auction.starts_at < Time.zone.now || !auction.english?
          skipped_auctions << auction.domain_name

          next
        end

        auction.starts_at = auctions_data[:set_starts_at] unless auctions_data[:set_starts_at].empty?
        auction.ends_at = auctions_data[:set_ends_at] unless auctions_data[:set_ends_at].empty?
        auction.starting_price = auctions_data[:starting_price] unless auctions_data[:starting_price].empty?
        auction.min_bids_step = auction.starting_price unless auctions_data[:starting_price].empty?
        auction.slipping_end = auctions_data[:slipping_end] unless auctions_data[:slipping_end].empty?

        if auction.save!
          SetHighestBidJob.perform_now(auction.id)
        end
      end
      if skipped_auctions.empty?
        flash[:notice] = 'New value was set'
        redirect_to admin_auctions_path
      else
        flash[:notice] = "These auctions were skipped: #{skipped_auctions.join(' ')}"
        redirect_to admin_auctions_path
      end
    end

    private

    def validate_table(table)
      first_row = table.headers
      first_row[0] == 'id' &&
        first_row[1] == 'domain' &&
        first_row[2] == 'status' &&
        first_row[3] == 'uuid' &&
        first_row[4] == 'created_at' &&
        first_row[5] == 'registration_code' &&
        first_row[6] == 'registration_deadline' &&
        first_row[7] == 'platform'
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
