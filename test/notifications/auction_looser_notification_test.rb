require 'test_helper'

class AuctionLooserNotificationTest < ActiveSupport::TestCase
  setup do
    @user = users(:participant)
    @auction = auctions(:english)
  end

  def test_should_inform_user_that_he_lose_auction
    assert_equal @user.notifications.count, 0
    AuctionLooserNotification.with(auction: @auction).deliver_later(@user)
    @user.reload

    assert_equal @user.notifications.count, 1
    notification = @user.notifications.first
    assert_equal notification.to_notification.message,
                 I18n.t('.participant_lost_auction', name: @auction.domain_name)
  end
end
