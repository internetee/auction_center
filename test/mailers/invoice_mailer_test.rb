require 'test_helper'
require 'support/mock_summary_report'

class InvoiceMailerTest < ActionMailer::TestCase
  def setup
    super

    @time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to @time

    @user_en = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    @auction_en = Auction.new(domain_name: 'example.test')
    @billing_profile_en = BillingProfile.new(user: @user_en)
    @result_en = Result.new(user: @user_en, auction: @auction_en, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)
    @invoice_en = Invoice.new(result: @result_en, user: @user_en, billing_profile: @billing_profile_en,
                          due_date: Date.today)

    @user_et = User.new(email: 'some@email.com', locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    @auction_et = Auction.new(domain_name: 'example.test')
    @billing_profile_et = BillingProfile.new(user: @user_et)
    @result_et = Result.new(user: @user_et, auction: @auction_et, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)
    @invoice_et = Invoice.new(result: @result_et, user: @user_et, billing_profile: @billing_profile_et,
                          due_date: Date.today)
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_reminder_email_english
    email = InvoiceMailer.reminder_email(@invoice_en)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "example.test invoice due date", email.subject
  end

  def test_reminder_email_estonian
    email = InvoiceMailer.reminder_email(@invoice_et)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["some@email.com"], email.to
    assert_equal "example.test arve tasumise tähtaeg", email.subject
  end
end