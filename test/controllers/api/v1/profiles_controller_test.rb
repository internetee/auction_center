# frozen_string_literal: true

require 'test_helper'
require 'jwt'

class Api::V1::ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:participant)
    @jwt_secret = Rails.application.config.customization[:jwt_secret] || 'jwt_secret'
    @token = JWT.encode({ sub: @user.id }, @jwt_secret, 'HS256')
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    stub_billing_api_calls
  end

  def test_create_new_user_profile
    assert_difference 'User.count' do
      post api_v1_profiles_url,
           params: { user: { email: 'test@example.com', password: 'password', password_confirmation: 'password', country_code: 'EE', given_names: 'John', surname: 'Doe', mobile_phone: '+1234567890', accepts_terms_and_conditions: true, locale: 'en' } },
           as: :json

      assert_response :success
    end
  end

  def test_update_user_profile
    assert_equal @user.given_names, 'Joe John'
    assert_equal @user.surname, 'Participant'

    put api_v1_profiles_url,
        params: { user: { email: 'test@example.com', password: 'password', password_confirmation: 'password', country_code: 'EE', given_names: 'John', surname: 'Doe', mobile_phone: '+1234567890', accepts_terms_and_conditions: true, locale: 'en' } },
        headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
        as: :json

    @user.reload

    assert_response :success
    assert_equal @user.given_names, 'John'
    assert_equal @user.surname, 'Doe'
  end

  private

  def stub_billing_api_calls
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator')
      .to_return(status: 200, body: { reference_number: '1234567890' }.to_json, headers: {})
  end
end
