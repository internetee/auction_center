# frozen_string_literal: true

class EmailConfirmationsController < Devise::ConfirmationsController
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      flash[:notice] = t('devise.confirmations.send_instructions')
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      flash[:alert] = resource.errors.full_messages.join(', ')
      redirect_to root_path, status: :see_other
    end
  end

  protected

  # The path used after confirmation.
  def after_confirmation_path_for(_resource_name, resource)
    sign_in(resource)
    user_path(resource.uuid)
  end
end
