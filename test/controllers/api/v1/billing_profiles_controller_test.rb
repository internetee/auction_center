# frozen_string_literal: true

require 'test_helper'
require 'jwt'

class Api::V1::BillingProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:participant)
    @jwt_secret = Rails.application.config.customization[:jwt_secret] || 'jwt_secret'
    @token = JWT.encode({ sub: @user.id }, @jwt_secret, 'HS256')
    stub_billing_api_calls
  end

  test 'should create billing profile' do
    post api_v1_billing_profiles_url,
         params: { billing_profile: { name: 'Test Billing Profile', vat_code: '1234567890', street: '123 Main St', city: 'Anytown', state: 'CA', postal_code: '12345', alpha_two_country_code: 'US', uuid: '123e4567-e89b-12d3-a456-426614174000' } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 'Test Billing Profile', json['billing_profile']['name']
    assert_equal '1234567890', json['billing_profile']['vat_code']
    assert_equal '123 Main St', json['billing_profile']['street']
    assert_equal 'Anytown', json['billing_profile']['city']
    assert_equal 'CA', json['billing_profile']['state']
    assert_equal '12345', json['billing_profile']['postal_code']
    assert_equal 'US', json['billing_profile']['alpha_two_country_code']
    assert_equal '123e4567-e89b-12d3-a456-426614174000', json['billing_profile']['uuid']
  end

  test 'should update billing profile' do
    put api_v1_billing_profile_url(@user.billing_profiles.first.id),
        params: { billing_profile: { name: 'Updated Billing Profile' } },
        headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
        as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 'Updated Billing Profile', json['billing_profile']['name']
  end

  test 'should not create billing profile with duplicate VAT code' do
    vat_code = @user.billing_profiles.first.vat_code
    post api_v1_billing_profiles_url,
         params: { billing_profile: { name: 'Test Billing Profile', vat_code:, street: '123 Main St', city: 'Anytown', state: 'CA', postal_code: '12345', alpha_two_country_code: 'US', uuid: '123e4567-e89b-12d3-a456-426614174000' } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal 'Vat code is already taken', json['errors']['vat_code'][0]
  end

  def stub_billing_api_calls
    stub_request(:patch, 'http://eis_billing_system:3000/api/v1/invoice/update_invoice_data')
      .to_return(status: 200, body: { invoice_number: '1234567890', transaction_amount: 100 }.to_json, headers: {})
  end
end