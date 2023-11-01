require 'test_helper'
require 'messente/omnimessage'

class PhoneConfirmationTest < ActiveSupport::TestCase
  def setup
    super

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator").
      to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})

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
    assert_not(@phone_confirmation.confirmed?)
  end

  def test_valid_code_returns_boolean
    assert(@phone_confirmation.valid_code?('0000'))
    assert_not(@phone_confirmation.valid_code?('Anything else'))
  end

  def test_when_user_is_invalid_code_is_not_sent
    @user.mobile_phone = 'foo'
    @user.save(validate: false)

    assert_not(@phone_confirmation.generate_and_send_code)
  end

  def test_when_phone_confirmed_by_other_code_not_set
    another_user = users(:second_place_participant)
    @user.update!(mobile_phone_confirmed_at: Time.zone.now - 1.day)
    confirmation = PhoneConfirmation.new(another_user)

    assert_not(confirmation.generate_and_send_code)
  end

  def test_confirm_exits_early_if_already_confirmed
    @user.mobile_phone_confirmed_at = Time.zone.now
    @user.save

    assert_not(@phone_confirmation.confirm)
    assert(@phone_confirmation.confirmed?)
  end

  def test_confirm_defaults_to_current_current_time
    time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to time

    assert(@phone_confirmation.confirm)
    assert_equal(@user.mobile_phone_confirmed_at, time)

    travel_back
  end

  def test_user_phone_number_confirmed?
    assert_not(@user.phone_number_confirmed?)
  end

  def test_generate_and_send_code_updates_phone_number_confirmation_code
    mock = Minitest::Mock.new
    response = {
      messages: [{
        channel: 'sms',
        message_id: '02a632d6-9c7c-436e-8b9c-ea3ef636724c',
        sender: '+37255000002',
      }],
      omnimessage_id: '75cbf2b6-74e8-4c75-8093-f1041587cd04',
      to: '+37255000001',
    }

    mock.expect(:send_message, ['201', response])

    Messente::Omnimessage.stub(:new, mock) do
      @phone_confirmation.generate_and_send_code
    end

    @user.reload
    assert_not(@phone_confirmation.code == '0000')
    assert_match(/\d{4}/, @user.mobile_phone_confirmation_code)
  end
end
