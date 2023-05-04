require 'test_helper'

class PushSubscriptionTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:participant)
  end

  def test_should_return_nil_if_no_current_user
    assert_no_difference -> { WebpushSubscription.count } do
      post '/push_subscriptions'
    end

    assert_equal response.status, 204
  end

  def test_should_update_subscription_if_the_same_user_again_subscribe_to_webpush
    sign_in @user

    assert_no_difference -> { WebpushSubscription.count } do
      post '/push_subscriptions', params: { subscription: { endpoint: '/new', p256dh: 'new', auth: 'new' } }
    end

    @user.reload
    assert_equal response.status, 201

    assert_equal @user.webpush_subscription.endpoint, '/new'
    assert_equal @user.webpush_subscription.p256dh, 'new'
    assert_equal @user.webpush_subscription.auth, 'new'
  end

  def test_should_add_subscription_user_data_to_db
    sign_in @user
    @user.webpush_subscription.destroy
    @user.reload

    assert_difference -> { WebpushSubscription.count } do
      post '/push_subscriptions', params: { subscription: { endpoint: '/new', p256dh: 'new', auth: 'new' } }
    end

    @user.reload
    assert_equal response.status, 201

    assert_equal @user.webpush_subscription.endpoint, '/new'
    assert_equal @user.webpush_subscription.p256dh, 'new'
    assert_equal @user.webpush_subscription.auth, 'new'
  end
end
