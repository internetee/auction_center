# frozen_string_literal: true

require 'test_helper'
require 'jwt'

class Api::V1::AutobidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:participant)
    @second_user = users(:second_place_participant)
    @english_auction = auctions(:english)
    @jwt_secret = Rails.application.config.customization[:jwt_secret] || 'jwt_secret'
    @token = JWT.encode({ sub: @user.id }, @jwt_secret, 'HS256')
    @second_user_token = JWT.encode({ sub: @second_user.id }, @jwt_secret, 'HS256')
    
    # Enable mobile API for tests
    Rails.application.config.customization[:mobile_api] = { enabled: true }
    
    @active_auction = Auction.new(
      domain_name: 'active-test.test',
      starts_at: Time.now.utc - 1.hour,
      ends_at: Time.now.utc + 1.hour,
      platform: 'english',
      starting_price: 5.0,
      min_bids_step: 5.0,
      slipping_end: 5,
      skip_validation: true
    )
    @active_auction.save!
  end

  test 'should return 403 when mobile API is disabled' do
    Rails.application.config.customization[:mobile_api] = { enabled: false }
    
    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @english_auction.domain_name, price: 100.0 } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :forbidden
    json = JSON.parse(response.body)
    assert_equal 'API is turned off', json['errors']
  end

  test 'should return unauthorized without token' do
    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @english_auction.domain_name, price: 100.0 } },
         as: :json

    assert_response :unauthorized
    json = JSON.parse(response.body)
    assert_equal 'Unauthorized', json['errors']
  end

  test 'should return unauthorized with invalid token' do
    invalid_token = JWT.encode({ sub: @user.id }, 'invalid_secret', 'HS256')

    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @english_auction.domain_name, price: 100.0 } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{invalid_token}" },
         as: :json

    assert_response :unauthorized
  end

  test 'should return unauthorized with malformed token' do
    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @english_auction.domain_name, price: 100.0 } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer invalid_token_format" },
         as: :json

    assert_response :unauthorized
  end

  test 'should create new autobider successfully' do
    assert_difference('Autobider.count', 1) do
      post api_v1_autobiders_url,
           params: { autobider: { domain_name: @active_auction.domain_name, price: 100.0 } },
           headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
           as: :json
    end

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal 'ok', json['status']

    autobider = Autobider.last
    assert_equal @user.id, autobider.user_id
    assert_equal @active_auction.domain_name, autobider.domain_name
    assert_equal 10000, autobider.cents # 100.0 EUR in cents
    assert autobider.enable
  end

  test 'should update existing autobider' do
    existing_autobider = Autobider.create!(
      user: @user,
      domain_name: @active_auction.domain_name,
      cents: 5000,
      enable: false
    )

    assert_no_difference('Autobider.count') do
      post api_v1_autobiders_url,
           params: { 
             autobider: { 
               id: existing_autobider.id,
               domain_name: @active_auction.domain_name, 
               price: 150.0 
             } 
           },
           headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
           as: :json
    end

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal 'ok', json['status']

    existing_autobider.reload
    assert_equal 15000, existing_autobider.cents # 150.0 EUR in cents
    assert existing_autobider.enable
  end

  test 'should not update autobider belonging to different user' do
    other_autobider = Autobider.create!(
      user: @second_user,
      domain_name: @active_auction.domain_name,
      cents: 5000,
      enable: false
    )

    assert_difference('Autobider.count', 1) do
      post api_v1_autobiders_url,
           params: { 
             autobider: { 
               id: other_autobider.id,
               domain_name: @active_auction.domain_name, 
               price: 150.0 
             } 
           },
           headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
           as: :json
    end

    assert_response :ok
    other_autobider.reload
    assert_equal 5000, other_autobider.cents # Unchanged
    assert_not other_autobider.enable # Unchanged
  end

  test 'should return error for invalid autobider data' do
    assert_no_difference('Autobider.count') do
      post api_v1_autobiders_url,
           params: { autobider: { domain_name: @active_auction.domain_name, price: -10.0 } },
           headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
           as: :json
    end

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal 'error', json['status']
  end

  test 'should return error for zero price' do
    assert_no_difference('Autobider.count') do
      post api_v1_autobiders_url,
           params: { autobider: { domain_name: @active_auction.domain_name, price: 0 } },
           headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
           as: :json
    end

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal 'error', json['status']
  end

  test 'should call AutobiderService.autobid when creating autobider' do
    spy_on_autobider_service = Spy.on(AutobiderService, :autobid)

    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @active_auction.domain_name, price: 100.0 } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :ok
    assert spy_on_autobider_service.has_been_called?
  end

  test 'should skip autobid when user is last bidder' do
    # Create an offer from the same user first
    Offer.create!(
      auction: @active_auction,
      user: @user,
      cents: 5000,
      billing_profile: billing_profiles(:private_person),
      username: 'testuser'
    )

    spy_on_autobider_service = Spy.on(AutobiderService, :autobid)

    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @active_auction.domain_name, price: 100.0 } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :ok
    assert_not spy_on_autobider_service.has_been_called?
  end

  test 'should not skip autobid when different user is last bidder' do
    second_user_profile = BillingProfile.create!(
      user: @second_user,
      name: 'Second User Profile',
      alpha_two_country_code: 'EE',
      city: 'Tallinn',
      street: 'Test St',
      postal_code: '12345'
    )

    Offer.create!(
      auction: @active_auction,
      user: @second_user,
      cents: 5000,
      billing_profile: second_user_profile,
      username: 'otheruser'
    )

    spy_on_autobider_service = Spy.on(AutobiderService, :autobid)

    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @active_auction.domain_name, price: 100.0 } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :ok
    assert spy_on_autobider_service.has_been_called?
  end

  test 'should call broadcast service after successful creation' do
    spy_on_broadcast_service = Spy.on(Auctions::UpdateListBroadcastService, :call)

    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @active_auction.domain_name, price: 100.0 } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :ok
    assert spy_on_broadcast_service.has_been_called?
  end

  test 'should not handle domain name that does not exist' do
    assert_no_difference('Autobider.count') do
      post api_v1_autobiders_url,
           params: { autobider: { domain_name: 'nonexistent.test', price: 100.0 } },
           headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
           as: :json
    end

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal 'error', json['status']
    assert_equal I18n.t('autobider.domain_name.does_not_exist'), json['message']
  end

  test 'should handle missing required parameters' do
    assert_no_difference('Autobider.count') do
      post api_v1_autobiders_url,
           params: { autobider: { price: 100.0 } },
           headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
           as: :json
    end

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal 'error', json['status']
  end

  test 'should handle empty parameters' do
    post api_v1_autobiders_url,
         params: {},
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :bad_request
  end

  test 'should set autobider enabled to true for both new and existing' do
    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @active_auction.domain_name, price: 100.0 } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    autobider = Autobider.last
    assert autobider.enable

    autobider.update!(enable: false)
    
    post api_v1_autobiders_url,
         params: { 
           autobider: { 
             id: autobider.id,
             domain_name: @active_auction.domain_name, 
             price: 200.0 
           } 
         },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    autobider.reload
    assert autobider.enable
  end

  test 'should handle duplicate domain name for same user by updating' do
    existing = Autobider.create!(
      user: @user,
      domain_name: @active_auction.domain_name,
      cents: 5000,
      enable: true
    )

    existed_autobider = Autobider.where(domain_name: @active_auction.domain_name).order(:created_at).last

    assert_no_difference('Autobider.count') do
      post api_v1_autobiders_url,
           params: { autobider: { id: existed_autobider.id, domain_name: @active_auction.domain_name, price: 100.0 } },
           headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
           as: :json
    end

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal 'ok', json['status']
    
    existing.reload
    assert_equal 10000, existing.cents
  end

  test 'should find auction by domain name and call autobid service' do
    spy_on_autobider_service = Spy.on(AutobiderService, :autobid)
    spy_on_broadcast_service = Spy.on(Auctions::UpdateListBroadcastService, :call)

    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @active_auction.domain_name, price: 100.0 } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :ok
    assert spy_on_autobider_service.has_been_called?
    assert spy_on_broadcast_service.has_been_called?
  end

  test 'should handle decimal prices correctly' do
    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @active_auction.domain_name, price: 123.45 } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :ok
    
    autobider = Autobider.last
    assert_equal 12345, autobider.cents
  end

  test 'should handle string prices correctly' do
    post api_v1_autobiders_url,
         params: { autobider: { domain_name: @active_auction.domain_name, price: '99.99' } },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :ok
    
    autobider = Autobider.last
    assert_equal 9999, autobider.cents
  end

  test 'should only accept permitted parameters' do
    post api_v1_autobiders_url,
         params: { 
           autobider: { 
             domain_name: @active_auction.domain_name, 
             price: 100.0,
             enable: false,
             user_id: @second_user.id,
             extra_param: 'ignored'
           } 
         },
         headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
         as: :json

    assert_response :ok
    
    autobider = Autobider.last
    assert_equal @user.id, autobider.user_id
    assert autobider.enable
  end

end