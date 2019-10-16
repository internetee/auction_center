require 'test_helper'

class UsersIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionMailer::TestHelper

  setup do
    @user = users(:participant)
    sign_in @user
  end

  def test_user_is_notified_about_password_change
    current_password = 'password123'
    new_password = 'new password'

    assert_enqueued_emails 1 do
      patch user_path(@user.uuid), params: { user: { current_password: current_password,
                                                     password: new_password,
                                                     password_confirmation: new_password } }
    end
  end
end
