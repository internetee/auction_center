require 'test_helper'

class PhoneConfirmationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
  end

  def phone_confirmation_path
    "/users/#{@user.uuid}/phone_confirmations"
  end

  def new_phone_confirmation_path
    "/users/#{@user.uuid}/phone_confirmations/new"
  end

  def sign_in_and_stub_phone_confirmation(confirmed:, valid_code:, confirm_result:)
    user = @user
    phone_confirmation = Object.new
    phone_confirmation.define_singleton_method(:user) { user }
    phone_confirmation.define_singleton_method(:confirmed?) { confirmed }
    phone_confirmation.define_singleton_method(:valid_code?) { |_code| valid_code }
    phone_confirmation.define_singleton_method(:confirm) { confirm_result }

    PhoneConfirmation.stub(:new, phone_confirmation) do
      sign_in @user
      yield
    end
  end

  def test_new_requires_authentication
    get new_phone_confirmation_path
    assert_redirected_to new_user_session_path
  end

  def test_new_redirects_to_user_when_already_confirmed
    sign_in_and_stub_phone_confirmation(confirmed: true, valid_code: false, confirm_result: false) do
      get new_phone_confirmation_path
    end
    assert_redirected_to user_path(@user.uuid)
  end

  def test_create_redirects_to_user_when_code_is_valid
    sign_in_and_stub_phone_confirmation(confirmed: false, valid_code: true, confirm_result: true) do
      post phone_confirmation_path, params: { phone_confirmation: { confirmation_code: '1234' } }
    end
    assert_redirected_to user_path(@user.uuid)
  end

  def test_create_redirects_back_when_code_is_invalid
    sign_in_and_stub_phone_confirmation(confirmed: false, valid_code: false, confirm_result: false) do
      post phone_confirmation_path, params: { phone_confirmation: { confirmation_code: '9999' } }
    end
    assert_redirected_to new_user_phone_confirmation_path(@user.uuid)
  end
end
