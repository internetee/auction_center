require 'test_helper'

class PhoneConfirmationTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:participant)
    @phone_confirmation = PhoneConfirmation.new(@user)
  end

  def teardown
    super
  end

  def test_class_initialization
    assert_equal(@phone_confirmation.user, @user)
    assert_equal(@phone_confirmation.code, @user.phone_number_confirmation_code)
    refute(@phone_confirmation.confirmed?)
  end

  def test_valid_code_returns_boolean
    assert(@phone_confirmation.valid_code?('0000'))
    refute(@phone_confirmation.valid_code?('Anything else'))
  end

  def test_confirm_exits_early_if_already_confirmed
    @user.phone_number_confirmed_at = Time.zone.now
    @user.save

    refute(@phone_confirmation.confirm)
    assert(@phone_confirmation.confirmed?)
  end

  def test_confirm_defaults_to_current_current_time
    time = Time.parse('2010-07-05 10:30 +0000')
    travel_to time

    assert(@phone_confirmation.confirm)
    assert_equal(@user.phone_number_confirmed_at, time)

    travel_back
  end

  def test_user_phone_number_confirmed?
    refute(@user.phone_number_confirmed?)
  end
end
