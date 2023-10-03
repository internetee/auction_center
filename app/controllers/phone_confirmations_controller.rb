class PhoneConfirmationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_phone_confirmation
  before_action :authorize_user

  include RecaptchaValidatable
  recaptcha_action 'phone_confirmation'

  def new
    if @phone_confirmation.confirmed?
      redirect_to edit_user_path(@phone_confirmation.user.uuid), notice: t('.already_confirmed')
    elsif @phone_confirmation.user.not_phone_number_confirmed_unique?
      redirect_to edit_user_path(@phone_confirmation.user.uuid)
    end
  end

  def create
    user_uuid = @phone_confirmation.user.uuid

    respond_to do |format|
      if create_predicate
        format.html { redirect_to edit_user_path(user_uuid), notice: t('.confirmed') }
        format.json { redirect_to edit_user_path(user_uuid), status: :created, location: @user }
      else
        format.html do
          redirect_to new_user_phone_confirmation_path(user_uuid),
                      notice: t('phone_confirmations.invalid_code')
        end
        format.json { render :new }
      end
    end
  end

  private

  def create_predicate
    @phone_confirmation.valid_code?(create_params[:confirmation_code]) &&
      @phone_confirmation.confirm
  end

  def create_params
    params.require(:phone_confirmation).permit(:confirmation_code)
  end

  def set_phone_confirmation
    @phone_confirmation = PhoneConfirmation.new(current_user)
  end

  def authorize_user
    authorize! :manage, PhoneConfirmation
  end
end
