class PhoneConfirmation
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def code
    @user.phone_number_confirmation_code
  end

  def confirmed?
    @user.phone_number_confirmed_at.present?
  end
end
