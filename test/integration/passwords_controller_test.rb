require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:participant)
  end

  def post_reset_password(email)
    post user_password_path, params: { user: { email: email } }
  end

  def test_create_redirects_after_sending_instructions
    post_reset_password(@user.email)

    assert_response :redirect
    assert_nil flash[:alert]
  end

  def test_create_redirects_to_root_with_alert_when_sending_fails
    failing_resource = User.new
    failing_resource.errors.add(:email, 'not found')

    User.stub(:send_reset_password_instructions, failing_resource) do
      post_reset_password('missing@example.test')
    end

    assert_response :see_other
    assert_redirected_to root_path
    assert_includes flash[:alert], 'not found'
  end
end
