class PhoneConfirmations::SendSmsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_phone_confirmation
  before_action :authorize_user

  include RecaptchaValidatable
  recaptcha_action 'send_sms'

  def create
    if current_user.allow_to_send_sms_again? 
      PhoneConfirmationJob.perform_now(@phone_confirmation.user.id)

      flash[:notice] = I18n.t('phone_confirmations.create.sms_sent')
    else
      flash[:alert] = I18n.t('phone_confirmations.create.sms_not_sent')
    end

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
