class AutobiderController < ApplicationController
  before_action :authenticate_user!
  before_action :allow_any_action_with_autobider
  before_action :set_captcha_required
  before_action :captcha_check, only: [:update, :create]

  def update
    @autobider = Autobider.find_by(uuid: params[:uuid])

    if @autobider.update(strong_params)
      auction = Auction.find_by(domain_name: @autobider.domain_name)

      AutobiderService.autobid(auction) unless skip_autobid(auction)
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

  private

  def set_captcha_required
    @captcha_required = current_user.requires_captcha?
  end

  def captcha_check
    captcha_predicate = !@captcha_required || verify_recaptcha(model: @autobider)

    return if captcha_predicate

    flash[:alert] = t('english_offers.form.captcha_verification')
    redirect_to request.referrer and return
  end

  def skip_autobid(auction)
    return false if auction.offers.empty?

    offer = auction.offers.order(:updated_at).last
    offer.user == @autobider.user
  end

  def allow_any_action_with_autobider
    return true if restrict_for_banned_user(strong_params[:domain_name])

    flash[:alert] = 'You are banned from this auction'
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
    params.require(:autobider).permit(:user_id, :domain_name, :price)
  end

  def create_predicate
    authorize! :create, @autobider
    @autobider.save
  end
end
