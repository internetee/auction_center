require 'test_helper'
require 'support/mock_summary_report'

class WishlistMailerTest < ActionMailer::TestCase
  def setup
    super

    @time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to @time

    @user_en = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    @auction_en = Auction.new(domain_name: 'example.test', ends_at: Time.zone.now,
                          uuid: SecureRandom.uuid)
    @item_en = WishlistItem.new(user: @user_en, domain_name: @auction_en.domain_name)

    @user_et = User.new(email: 'some@email.com', locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    @auction_et = Auction.new(domain_name: 'example.test', ends_at: Time.zone.now,
              uuid: SecureRandom.uuid)
    @item_et = WishlistItem.new(user: @user_et, domain_name: @auction_et.domain_name)
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_wishlist_mail_notification_english
    
    email = WishlistMailer.auction_notification_mail(@item_en, @auction_en)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "example.test is now on auction", email.subject
  end

  def test_wishlist_mail_notification_estonian
    email = WishlistMailer.auction_notification_mail(@item_et, @auction_et)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "example.test on nüüd oksjonil", email.subject
  end
end