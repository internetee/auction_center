require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
  end

  def test_index_requires_authentication
    get notifications_path

    assert_response :redirect
  end

  def test_index_renders_for_authenticated_user
    sign_in @user

    get notifications_path

    assert_response :ok
  end

  def test_mark_as_read_marks_unread_notifications_as_read
    sign_in @user
    Notification.create!(recipient: @user, type: 'OfferNotification', params: {})
    Notification.create!(recipient: @user, type: 'OfferNotification', params: {})

    patch mark_as_read_notifications_path

    assert_redirected_to notifications_path
    assert_equal 303, response.status
    assert_equal 0, @user.notifications.unread.count
    assert_equal 2, @user.notifications.read.count
  end
end
