# frozen_string_literal: true

require 'test_helper'
require 'jwt'

class Api::V1::InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:participant)
    @jwt_secret = Rails.application.config.customization[:jwt_secret] || 'jwt_secret'
    @token = JWT.encode({ sub: @user.id }, @jwt_secret, 'HS256')
  end

  test 'should get invoices' do
    get api_v1_invoices_url,
        headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
        as: :json

    all_invoices = Invoice.all

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal all_invoices.count, json['issued_invoices'].count
    assert_equal all_invoices.count, json['paid_invoices'].count
    assert_equal all_invoices.count, json['cancelled_payable_invoices'].count
    assert_equal all_invoices.count, json['cancelled_expired_invoices'].count
    assert_equal all_invoices.count, json['deposit_paid'].count
  end

  test 'should get one off payment' do
    get api_v1_one_off_payment_path(id: @user.invoices.first.uuid),
        headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
        as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 'https://example.com', json['oneoff_redirect_link']
  end
end