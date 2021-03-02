require 'test_helper'
require 'support/mock_summary_report'

class ResultMailerTest < ActionMailer::TestCase
  def setup
    super

    @time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to @time

    @user_en = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    @auction_en = Auction.new(domain_name: 'example.test')
    @result_en = Result.new(user: @user_en, auction: @auction_en, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)

    @user_et = User.new(email: 'some@email.com', locale: :et,
                        given_names: 'GivenNames', surname: 'Surname')
    @auction_et = Auction.new(domain_name: 'example.test')
    @result_et = Result.new(user: @user_et, auction: @auction_et, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_winner_email_english
    email = ResultMailer.winner_email(@result_en)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "Bid for the example.test domain was successful", email.subject
  end

  def test_winner_email_estonian
    email = ResultMailer.winner_email(@result_et)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "Pakkumine domeenile example.test oli edukas", email.subject
  end

  def test_registration_code_email_english
    email = ResultMailer.registration_code_email(@result_en)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "example.test registration code available", email.subject
  end

  def test_registration_code_email_estonian
    email = ResultMailer.registration_code_email(@result_et)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "example.test registreerimise kood on nüüd kättesaadav", email.subject
  end

  def test_participant_email_english
    email = ResultMailer.participant_email(@user_en, @auction_en)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "Bid for the example.test domain was unsuccessful", email.subject
  end

  def test_participant_email_estonian
    email = ResultMailer.participant_email(@user_et, @auction_et)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "Domeeni example.test pakkumine ei olnud edukas", email.subject
  end  
end