module Admin
  class AuctionsController < BaseController
    include OrderableHelper

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
      @auctions = Auction.includes(:offers)
                         .accessible_by(current_ability)
                         .order(orderable_array)
                         .page(params[:page])
    end

    # GET /admin/auctions/search
    def search
      domain_name = search_params[:domain_name]

      @auctions = Auction.where('domain_name ILIKE ?', "%#{domain_name}%")
                         .accessible_by(current_ability)
                         .includes(:offers)
                         .order(orderable_array)
                         .page(1)
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

    private

    def orderable_array
      orderable(order_params)
    end

    def search_params
      params.permit(:domain_name)
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
