require 'test_helper'

class OfferNotificationTest < ActiveSupport::TestCase
  setup do
    @user = users(:participant)
    @offer = offers(:high_offer)
  end

  def test_should_send_notification_to_user
    assert_equal @user.notifications.count, 0
    OfferNotification.with(offer: @offer).deliver_later(@user)
    @user.reload

    assert_equal @user.notifications.count, 1
  end

  def test_should_display_outbid_message
    OfferNotification.with(offer: @offer).deliver_later(@user)
    @user.reload

    notification = @user.notifications.first

    assert_equal notification.to_notification.message,
                 I18n.t('.participant_outbid', name: @offer.auction.domain_name)
  end
end
