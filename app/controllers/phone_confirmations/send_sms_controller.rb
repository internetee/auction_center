class PhoneConfirmations::SendSmsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_phone_confirmation
  before_action :authorize_user

  include RecaptchaValidatable
  recaptcha_action 'phone_confirmation'

  def create
    Rails.logger.info("PhoneConfirmations::SendSmsController#create: params=#{params.inspect}")
    Rails.logger.info('----------')
    Rails.logger.info(current_user.allow_to_send_sms_again?)
    Rails.logger.info(recaptcha_valid)
    Rails.logger.info(AuctionCenter::Application.config.customization[:mobile_sms_sent_time_limit_in_minutes].to_i.minutes)
    Rails.logger.info(PhoneConfirmation::TIME_LIMIT.ago)
    Rails.logger.info('----------')

    if current_user.allow_to_send_sms_again?
      PhoneConfirmationJob.perform_now(@phone_confirmation.user.id)

      flash[:notice] = I18n.t('phone_confirmations.create.sms_sent')
    else
      flash[:alert] = I18n.t('phone_confirmations.create.sms_not_sent')
    end

    @show_checkbox_recaptcha = true unless @success

    redirect_to new_user_phone_confirmation_path(@phone_confirmation.user.uuid), status: :see_other
  end

  private

  def set_phone_confirmation
    @phone_confirmation = PhoneConfirmation.new(current_user)
  end

  def authorize_user
    authorize! :manage, PhoneConfirmation
  end
end
