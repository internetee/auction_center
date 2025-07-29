# frozen_string_literal: true

require 'test_helper'
require 'jwt'

class Api::V1::InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:participant)
    @deposit_auction = auctions(:deposit_english)
    @jwt_secret = Rails.application.config.customization[:jwt_secret] || 'jwt_secret'
    @token = JWT.encode({ sub: @user.id }, @jwt_secret, 'HS256')

    stub_billing_api_calls
  end

  test 'should get invoices' do
    get api_v1_invoices_url,
        headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
        as: :json

    all_invoices = @user.invoices

    assert_response :success
    json = JSON.parse(response.body)

    assert_equal all_invoices.issued.count, json['issued_invoices'].count
    assert_equal all_invoices.paid.count, json['paid_invoices'].count
    assert_equal all_invoices.cancelled.with_ban.count, json['cancelled_payable_invoices'].count
    assert_equal all_invoices.cancelled.without_ban.count, json['cancelled_expired_invoices'].count
    assert_equal @user.domain_participate_auctions.count, json['deposit_paid'].count
  end

  test 'should get one off payment' do
    post api_v1_oneoff_payments_url(id: @user.invoices.first.uuid),
        headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
        as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 'http://oneoff.redirect', json['oneoff_redirect_link']
  end

  test 'should get pay deposit' do
    post api_v1_pay_deposits_url(id: @deposit_auction.uuid),
        headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
        as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 'http://oneoff.redirect', json['oneoff_redirect_link']
  end

  private

  def stub_billing_api_calls
    message = {
      oneoff_redirect_link: 'http://oneoff.redirect',
    }

    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/oneoff')
      .to_return(status: 200, body: message.to_json, headers: {})

    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/deposit_prepayment')
      .to_return(status: 200, body: message.to_json, headers: {})
  end
end