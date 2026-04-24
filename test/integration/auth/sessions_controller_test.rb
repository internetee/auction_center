require 'test_helper'

class AuthSessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:participant)
  end

  def post_session(email:, password:)
    post user_session_path, params: { user: { email:, password: } }
  end

  def test_create_signs_in_with_valid_credentials
    post_session(email: @user.email, password: 'password123')

    assert_response :redirect
    assert_redirected_to root_path
  end

  def test_create_rejects_invalid_credentials
    post_session(email: @user.email, password: 'wrong-password')

    assert_response :ok
    assert_includes flash[:alert], 'Invalid'
  end
end
