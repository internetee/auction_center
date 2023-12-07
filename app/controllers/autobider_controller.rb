class AutobiderController < ApplicationController
  before_action :authenticate_user!
  before_action :set_auction, only: %i[new edit update create]
  before_action :allow_any_action_with_autobider
  include RecaptchaValidatable

  def update
    @autobider = Autobider.find_by(uuid: params[:uuid])

    if recaptcha_valid
      if @autobider.update(strong_params)
        auction = Auction.where(domain_name: @autobider.domain_name).order(:created_at).last
        AutobiderService.autobid(auction) unless skip_autobid(auction)

        flash[:notice] = I18n.t('english_offers.form.autobidder_updated')
      else
        flash[:alert] = I18n.t('something_went_wrong')
      end
    else
      flash[:alert] = t('english_offers.form.captcha_verification')
    end

    render turbo_stream: turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: })
  end

  def edit
    @auction = Auction.find_by(uuid: params[:auction_uuid])
    @autobider = Autobider.find_by(uuid: params[:uuid])
  end

  def new
    @auction = Auction.find_by(uuid: params[:auction_uuid])
    @autobider = Autobider.new
  end

  def create
    @autobider = Autobider.new(strong_params)

    if recaptcha_valid
      if create_predicate
        auction = Auction.where(domain_name: @autobider.domain_name).order(:created_at).last
        AutobiderService.autobid(auction)

        flash[:notice] = t('english_offers.form.autobidder_created')
      else
        flash[:alert] = t('something_went_wrong')
      end
    else
      flash[:alert] = t('english_offers.form.captcha_verification')
    end

    render turbo_stream: turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: })
  end

  private

  def skip_autobid(auction)
    return false if auction.offers.empty?

    offer = auction.offers.order(:updated_at).last
    offer.user == @autobider.user
  end

  def set_auction
    @auction = Auction.find_by(uuid: params[:auction_uuid])
    @auction = Auction.find_by(domain_name: strong_params[:domain_name]) if @auction.nil?
  end

  def allow_any_action_with_autobider
    return true if restrict_for_banned_user(@auction.domain_name)

    flash[:alert] = I18n.t('english_offers.form.banned')
    redirect_to auctions_path and return
  end

  def restrict_for_banned_user(domain_name)
    if current_user.completely_banned?
      return false
    elsif current_user.bans.valid.pluck(:domain_name).include?(domain_name)
      return false
    end

    true
  end

  def strong_params
    params.require(:autobider).permit(:user_id, :domain_name, :price, :enable)
  end

  def create_predicate
    authorize! :create, @autobider
    @autobider.save
  end
end
