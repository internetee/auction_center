require 'test_helper'

class PhoneConfirmationTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:participant)
  end

  def teardown
    super
  end

  def test_class_initialization
    phone_confirmation = PhoneConfirmation.new(@user)

    assert_equal(phone_confirmation.user, @user)
    assert_equal(phone_confirmation.code, @user.phone_number_confirmation_code)
    refute(phone_confirmation.confirmed?)
  end
end
