# frozen_string_literal: true

require 'test_helper'
require 'jwt'

class Api::V1::AuctionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:participant)
    @auction = auctions(:valid_with_offers)
    @jwt_secret = Rails.application.config.customization[:jwt_secret] || 'jwt_secret'
    @token = JWT.encode({ sub: @user.id }, @jwt_secret, 'HS256')
  end

  test 'should show auction data for authorized user' do
    get api_v1_auctions_url(auction_id: @auction.uuid),
      headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
      as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json['offer']
    assert json['autobider']
    assert json['billing_profiles']
  end

  test 'should return unauthorized without token' do
    get api_v1_auctions_url(auction_id: @auction.uuid), as: :json
    assert_response :unauthorized
  end
end 