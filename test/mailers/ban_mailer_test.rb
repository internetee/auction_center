require 'test_helper'
require 'support/mock_summary_report'

class BanMailerTest < ActionMailer::TestCase
  def setup
    super

    @time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to @time

    @user = users(:participant)
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_short_ban_mail_english
    ban = Ban.new(user: @user)
    email = BanMailer.short_ban_mail(ban, 2, 'banned.test')

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "Participation in banned.test auction prohibited", email.subject
  end

  def test_short_ban_mail_estonian
    @user.update(locale: 'et')
    @user.reload
    ban = Ban.new(user: @user)
    email = BanMailer.short_ban_mail(ban, 2, 'banned.test')
    
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "banned.test oksjonil osalemise keeld", email.subject
  end

  def test_long_ban_mail_english
    ban = Ban.new(user: @user, valid_until: Date.today >> 12)
    email = BanMailer.long_ban_mail(ban, 2, 'banned.test')

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "Participation in auctions prohibited", email.subject
  end

  def test_long_ban_mail_estonian
    @user.update(locale: 'et')
    @user.reload
    ban = Ban.new(user: @user, valid_until: Date.today >> 12)
    email = BanMailer.long_ban_mail(ban, 2, 'banned.test')

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "Oksjonitel osalemise keeld", email.subject
  end
end