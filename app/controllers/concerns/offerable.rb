module Offerable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :find_auction, only: %i[new create]
    before_action :check_for_ban, only: :create
    before_action :authorize_phone_confirmation
  end

  protected

  def check_for_ban
    is_ban = Ban.valid.where(user_id: current_user).where(domain_name: @auction.domain_name).any?
    is_ban ||= current_user.completely_banned?
    return unless is_ban

    redirect_to root_path, flash: { alert: I18n.t("#{params[:controller]}.create.ban") } and return
  end

  def inform_invalid_captcha
    @show_checkbox_recaptcha = true unless @success
    flash[:alert] = t('offers.form.captcha_verification')
    redirect_to root_path, status: :see_other
  end

  private

  def update_not_allowed(auction) = if params[:controller] == 'english_offers'
                                      !auction.english? || !auction.in_progress?
                                    else
                                      auction.english? || !auction.in_progress?
                                    end

  def prevent_check_for_existed_offer = if turbo_frame_request?
                                          render turbo_stream: turbo_stream.action(:redirect, root_path),
                                                 notice: t('offers.already_exists')
                                        else
                                          redirect_to root_path, status: :see_other,
                                                                 notice: t('offers.already_exists')
                                        end

  def set_offer
    @offer = current_user.offers.find_by!(uuid: params[:uuid])
  end

  def find_auction
    controller_name = params[:controller]
    platform = controller_name == 'english_offers' ? 'english' : ['blind', nil]

    @auction = Auction.find_by!(uuid: params[:auction_uuid], platform:)
  end

  def authorize_phone_confirmation
    return unless current_user.requires_phone_number_confirmation?

    flash[:notice] = t('phone_confirmations.confirmation_required')

    if turbo_frame_request?
      render turbo_stream: turbo_stream.action(:redirect, new_user_phone_confirmation_path(current_user.uuid))
    else
      redirect_to new_user_phone_confirmation_path(current_user.uuid), status: :see_other
    end
  end

  def authorize_offer_for_user
    authorize! :manage, @offer
  end
end
