class PhoneConfirmationJob < ApplicationJob
  def perform(user_id)
    user = User.find(user_id)
    phone_confirmation = PhoneConfirmation.new(user)
    return if phone_confirmation.confirmed?

    phone_confirmation.generate_and_send_code
  end
end
