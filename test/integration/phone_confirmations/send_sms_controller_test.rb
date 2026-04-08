require 'test_helper'

class PhoneConfirmationsSendSmsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
  end

  def send_sms
    post "/users/#{@user.uuid}/phone_confirmations/send_sms"
  end

  def sign_in_and_send_sms
    sign_in @user
    send_sms
  end

  def stub_phone_confirmation_job
    called = false
    PhoneConfirmationJob.stub(:perform_now, ->(_user_id) { called = true }) do
      yield
    end
    called
  end

  def test_create_requires_authentication
    send_sms
    assert_redirected_to new_user_session_path
  end

  def test_create_sends_sms_when_allowed
    @user.update!(mobile_phone_confirmed_sms_send_at: nil)
    called = stub_phone_confirmation_job { sign_in_and_send_sms }

    assert called
    assert_response :see_other
    assert_redirected_to new_user_phone_confirmation_path(@user.uuid)
    assert_equal I18n.t('phone_confirmations.create.sms_sent'), flash[:notice]
  end

  def test_create_sets_alert_when_sms_cannot_be_sent_yet
    @user.update!(mobile_phone_confirmed_sms_send_at: Time.current)
    sign_in_and_send_sms

    assert_response :see_other
    assert_redirected_to new_user_phone_confirmation_path(@user.uuid)
    assert_equal I18n.t('phone_confirmations.create.sms_not_sent'), flash[:alert]
  end
end
