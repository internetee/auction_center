require 'test_helper'
require 'messente/omnimessage'

class PhoneConfirmationTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:participant)
    @user.update!(mobile_phone_confirmed_at: nil)
    @phone_confirmation = PhoneConfirmation.new(@user)
  end

  def teardown
    super
  end

  def test_class_initialization
    assert_equal(@phone_confirmation.user, @user)
    assert_equal(@phone_confirmation.code, @user.mobile_phone_confirmation_code)
    refute(@phone_confirmation.confirmed?)
  end

  def test_valid_code_returns_boolean
    assert(@phone_confirmation.valid_code?('0000'))
    refute(@phone_confirmation.valid_code?('Anything else'))
  end

  def test_confirm_exits_early_if_already_confirmed
    @user.mobile_phone_confirmed_at = Time.zone.now
    @user.save

    refute(@phone_confirmation.confirm)
    assert(@phone_confirmation.confirmed?)
  end

  def test_confirm_defaults_to_current_current_time
    time = Time.parse('2010-07-05 10:30 +0000')
    travel_to time

    assert(@phone_confirmation.confirm)
    assert_equal(@user.mobile_phone_confirmed_at, time)

    travel_back
  end

  def test_user_phone_number_confirmed?
    refute(@user.phone_number_confirmed?)
  end

  def test_generate_and_send_code_updates_phone_number_confirmation_code
    mock = Minitest::Mock.new
    response = {
      messages: [{
        channel: 'sms',
        message_id: '02a632d6-9c7c-436e-8b9c-ea3ef636724c',
        sender: '+37255000002'}],
      omnimessage_id: '75cbf2b6-74e8-4c75-8093-f1041587cd04',
      to: '+37255000001'
    }

    mock.expect(:send_message, ['201', response])

    Messente::Omnimessage.stub(:new, mock) do
      @phone_confirmation.generate_and_send_code
    end

    @user.reload
    refute(@phone_confirmation.code == '0000')
    assert_match(/\d{4}/, @user.mobile_phone_confirmation_code)
  end
end
