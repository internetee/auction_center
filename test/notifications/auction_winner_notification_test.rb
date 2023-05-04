require 'test_helper'

class AuctionWinnerNotificationTest < ActiveSupport::TestCase
  setup do
    @user = users(:participant)
    @auction = auctions(:english)
  end

  def test_should_inform_user_that_he_win_auction
    assert_equal @user.notifications.count, 0
    AuctionWinnerNotification.with(auction: @auction).deliver_later(@user)
    @user.reload

    assert_equal @user.notifications.count, 1
    notification = @user.notifications.first
    assert_equal notification.to_notification.message,
                 I18n.t('.participant_win_auction', name: @auction.domain_name)
  end
end
