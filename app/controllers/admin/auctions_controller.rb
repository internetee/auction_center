module Admin
  class AuctionsController < BaseController
    before_action :authorize_user
    before_action :set_auction, except: %i[index new create]

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
      @auctions = Auction.accessible_by(current_ability)
    end

    # GET /admin/auctions/1
    def show; end

    # GET /admin/auctions/1/edit
    def edit; end

    private

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
