# frozen_string_literal: true

require 'test_helper'
require 'jwt'

class Api::V1::OffersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:participant)
    @jwt_secret = Rails.application.config.customization[:jwt_secret] || 'jwt_secret'
    @token = JWT.encode({ sub: @user.id }, @jwt_secret, 'HS256')
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def test_show_offers
    offers = Offer.includes(:auction)
                      .includes(:result)
                      .where(user_id: @user)
                      .order('auctions.ends_at DESC')
    offers = offers.as_json(
      include: %i[auction billing_profile],
      methods: %i[auction_status api_price api_total api_bidders]
    )
                      
    get api_v1_offers_url, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" }, as: :json
    assert_response :success
    assert_equal offers, JSON.parse(response.body)
  end

  def test_create_offer
    auction = auctions(:valid_with_offers)

    assert_equal 50.00, auction.highest_price.to_f
    post api_v1_offers_url,
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         params: { bid: { auction_id: auction.uuid, price: 60 } },
         as: :json

    assert_response :success
    assert_equal 60.00, auction.highest_price.to_f
  end

  def test_update_offer_for_english_auction
    auction = auctions(:english)
    offer = auction.offers.first
    post api_v1_offers_url,
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         params: { bid: { auction_id: auction.uuid, price: 60, billing_profile_id: @user.billing_profiles.first.id } },
         as: :json

    auction.reload

    assert_response :success
    assert_equal 60.00, auction.highest_price.to_f
    assert_equal 61.00, auction.min_bids_step.to_f
  end
end