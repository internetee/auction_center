require 'test_helper'

class UsersIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionMailer::TestHelper

  setup do
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator").
      to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})

    @user = users(:participant)
    sign_in @user
  end

  def test_user_is_notified_about_password_change
    current_password = 'password123'
    new_password = 'new password'

    assert_enqueued_emails 1 do
      patch user_path(@user.uuid), params: { user: { current_password: current_password,
                                                     password: new_password,
                                                     password_confirmation: new_password } }
    end
  end

  def test_user_create_with_punicode
    assert_enqueued_emails 1 do
      post users_path, params: { 
        user: { 
          email: 'example@ää.eu',
          given_names: 'John',
          surname: 'Doe',
          password: 'password123',
          password_confirmation: 'password123',
          terms_and_conditions_accepted_at: Time.now.utc,
          locale: 'en',
          mobile_phone: '+37269900366',
          identity_code: '60001017793',
          country_code: 'EE',
          accepts_terms_and_conditions: true,
          roles: ['participant'],
          phone_number_confirmed: true,
          provider: 'email'}
      }
    end

    punicode = SimpleIDN.to_ascii('ää.eu')
    assert User.find_by(email: "example@#{punicode}")

    assert_redirected_to new_user_session_path
  end
end
