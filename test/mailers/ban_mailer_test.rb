require 'test_helper'
require 'support/mock_summary_report'

class BanMailerTest < ActionMailer::TestCase
  def setup
    super

    @time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to @time

    @user_en = User.new(email: 'some@email.com', locale: :en,
                        given_names: 'GivenNames', surname: 'Surname')
    @ban_short_en = Ban.new(user: @user_en)
    @ban_long_en = Ban.new(user: @user_en, valid_until: Date.today >> 12)

    @user_et = User.new(email: 'some@email.com', locale: :et,
                        given_names: 'GivenNames', surname: 'Surname')
    @ban_short_et = Ban.new(user: @user_et)
    @ban_long_et = Ban.new(user: @user_et, valid_until: Date.today >> 12)
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_short_ban_mail_english
    email = BanMailer.short_ban_mail(@ban_short_en, 2, 'banned.test')

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "Participation in banned.test auction prohibited", email.subject
  end

  def test_short_ban_mail_estonian
    email = BanMailer.short_ban_mail(@ban_short_et, 2, 'banned.test')
    
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "banned.test oksjonil osalemise keeld", email.subject
  end

  def test_long_ban_mail_english
    email = BanMailer.long_ban_mail(@ban_long_en, 2, 'banned.test')

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "Participation in auctions prohibited", email.subject
  end

  def test_long_ban_mail_estonian
    email = BanMailer.long_ban_mail(@ban_long_et, 2, 'banned.test')

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "Oksjonitel osalemise keeld", email.subject
  end
end