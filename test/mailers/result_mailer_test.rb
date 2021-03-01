require 'test_helper'
require 'support/mock_summary_report'

class ResultMailerTest < ActionMailer::TestCase
  def setup
    super

    @time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to @time

    @user = users(:participant)
    @local = @user.locale
    @auction = auctions(:valid_with_offers)
    @result = Result.new(user: @user, auction: @auction, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)
  end

  def teardown
    super

    @user.update(locale: @local)
    @user.reload
    clear_email_deliveries
    travel_back
  end

  def test_winner_email_english
    email = ResultMailer.winner_email(@result)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "Bid for the with-offers.test domain was successful", email.subject
  end

  def test_winner_email_estonian
    @user.update(locale: 'et')
    @user.reload
    
    email = ResultMailer.winner_email(@result)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "Pakkumine domeenile with-offers.test oli edukas", email.subject
  end

  def test_registration_code_email_english
    email = ResultMailer.registration_code_email(@result)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "with-offers.test registration code available", email.subject
  end

  def test_registration_code_email_estonian
    @user.update(locale: 'et')
    @user.reload
    email = ResultMailer.registration_code_email(@result)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "with-offers.test registreerimise kood on nüüd kättesaadav", email.subject
  end

  def test_participant_email_english
    email = ResultMailer.participant_email(@user, @auction)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "Bid for the with-offers.test domain was unsuccessful", email.subject
  end

  def test_participant_email_estonian
    @user.update(locale: 'et')
    @user.reload
    email = ResultMailer.participant_email(@user, @auction)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "Domeeni with-offers.test pakkumine ei olnud edukas", email.subject
  end  
end