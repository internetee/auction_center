# frozen_string_literal: true

class EmailConfirmationsController < Devise::ConfirmationsController
  protected

  # The path used after confirmation.
  def after_confirmation_path_for(_resource_name, resource)
    sign_in(resource)
    user_path(resource.uuid)
  end
end
