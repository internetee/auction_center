# frozen_string_literal: true

require 'test_helper'
require 'jwt'

class Api::V1::PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:participant)
    @jwt_secret = Rails.application.config.customization[:jwt_secret] || 'jwt_secret'
    @token = JWT.encode({ sub: @user.id }, @jwt_secret, 'HS256')
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def test_update_password
    assert @user.valid_password?('password123')

    put api_v1_profiles_passwords_url,
        params: { user: { password: 'newpassword', password_confirmation: 'newpassword', current_password: 'password123' } },
        headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
        as: :json

    @user.reload

    assert_response :success
    assert @user.valid_password?('newpassword')
  end

  def test_update_password_with_invalid_current_password
    assert @user.valid_password?('password123')

    put api_v1_profiles_passwords_url,
        params: { user: { password: 'newpassword', password_confirmation: 'newpassword', current_password: 'invalid' } },
        headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" },
        as: :json

    @user.reload

    assert_response :unprocessable_entity
    assert @user.valid_password?('password123')
  end
end