class PhoneConfirmationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_phone_confirmation
  before_action :authorize_user

  def new
  end

  def update
  end

  private

  def set_phone_confirmation
    @phone_confirmation = PhoneConfirmation.new(current_user)
  end

  def authorize_user
    authorize! :manage, PhoneConfirmation
  end
end
