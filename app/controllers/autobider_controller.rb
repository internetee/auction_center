class AutobiderController < ApplicationController
  before_action :authenticate_user!

  def update
    @autobider = Autobider.find_by(uuid: params[:uuid])
    # authorize! :update, @autobider

    if @autobider.update(strong_params)
      auction = Auction.find_by(domain_name: @autobider.domain_name)
      AutobiderService.autobid(auction)
      flash[:notice] = 'Updated'
    else
      flash[:alert] = I18n.t('something_went_wrong')
    end

    redirect_to auctions_path
  end

  def create
    @autobider = Autobider.new(strong_params)

    if create_predicate
      auction = Auction.find_by(domain_name: @autobider.domain_name)
      AutobiderService.autobid(auction)

      redirect_to auctions_path, notice: 'Autobider created'
    else
      redirect_to auctions_path, notice: t(:something_went_wrong)
    end
  end

  def strong_params
    params.require(:autobider).permit(:user_id, :domain_name, :price)
  end

  def create_predicate
    authorize! :create, @autobider
    @autobider.save
  end
end
