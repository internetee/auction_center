require 'test_helper'

class EmailConfirmationsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:participant)
  end

  def post_confirmation(email)
    post user_confirmation_path, params: { user: { email: email } }
  end

  def test_create_redirects_after_sending_confirmation_instructions
    post_confirmation(@user.email)

    assert_response :redirect
  end

  def test_create_redirects_to_root_with_alert_when_sending_fails
    failing_resource = User.new
    failing_resource.errors.add(:email, 'not found')

    User.stub(:send_confirmation_instructions, failing_resource) do
      post_confirmation('missing@example.test')
    end

    assert_response :see_other
    assert_redirected_to root_path
    assert_includes flash[:alert], 'not found'
    assert_nil flash[:notice]
  end
end
