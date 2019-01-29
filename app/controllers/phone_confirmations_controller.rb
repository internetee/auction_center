class PhoneConfirmationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_phone_confirmation
  before_action :authorize_user

  def new; end

  def create
    respond_to do |format|
      if create_predicate
        format.html { redirect_to user_path(@phone_confirmation.user.uuid), notice: t(:created) }
        format.json { redirect_to user_path(@phone_confirmation.user.uuid), status: :created, location: @user }
      else
        format.html do
          redirect_to new_user_phone_confirmation_path(@phone_confirmation.user.uuid),
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
