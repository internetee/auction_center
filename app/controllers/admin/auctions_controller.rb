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
      params[:admin] = 'true'

      collection_one = Auction.where.not('ends_at <= ?', Time.zone.now).pluck(:id)
      collection_two = Auction.where(starts_at: nil).pluck(:id)
      collection = Auction.where(id: collection_one + collection_two).search(params)

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

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def bulk_starts_at
      results = AdminBulkActionService.apply_for_english_auction(auction_elements: params[:auction_elements])
      skipped_auctions = results[0]
      problematic_auctions = results[1]

      skipped_text = "These auctions were skipped: #{skipped_auctions.join(' ')}" if skipped_auctions.present?
      problematic_text = if problematic_auctions.present?
                           problematic_auctions.map { |auction| "#{auction.name} - #{auction.errors}; " }.join('; ')
                         end

      problematic_text.insert(0, 'These auction have problems: ') if problematic_text.present?

      flash[:notice] = "#{skipped_text} #{problematic_text}"
      flash[:notice] = 'New value was set' unless flash[:notice].presence

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

      return unless auction_elements[:enable_deposit] == 'true' && auction_elements[:disable_deposit] == 'true'

      flash[:alert] = 'it cannot be enable and disable deposit in same action'
      redirect_to admin_auctions_path and return
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
