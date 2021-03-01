require 'test_helper'
require 'support/mock_summary_report'

class WishlistMailerTest < ActionMailer::TestCase
  def setup
    super

    @time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to @time

    @user = users(:participant)
    @auction = auctions(:valid_with_offers)
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_wishlist_mail_notification_english
    item = WishlistItem.new(user: @user, domain_name: @auction.domain_name)
    email = WishlistMailer.auction_notification_mail(item, @auction)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "with-offers.test is now on auction", email.subject
  end

  def test_wishlist_mail_notification_estonian
    @user.update(locale: 'et')
    @user.reload
    item = WishlistItem.new(user: @user, domain_name: @auction.domain_name)
    email = WishlistMailer.auction_notification_mail(item, @auction)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "with-offers.test on nüüd oksjonil", email.subject
  end
end