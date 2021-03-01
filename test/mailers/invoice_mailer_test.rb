require 'test_helper'
require 'support/mock_summary_report'

class InvoiceMailerTest < ActionMailer::TestCase
  def setup
    super

    @time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to @time

    @user = users(:participant)
    @auction = auctions(:valid_with_offers)
    @billing_profile = billing_profiles(:private_person)
    @result = Result.new(user: @user, auction: @auction, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)
    @invoice = invoices(:payable)
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_reminder_email_english
    email = InvoiceMailer.reminder_email(@invoice)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "with-invoice.test invoice due date", email.subject
  end

  def test_reminder_email_estonian
    @user.update(locale: 'et')
    @user.reload
    email = InvoiceMailer.reminder_email(@invoice)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ["noreply@internet.ee"], email.from
    assert_equal ["user@auction.test"], email.to
    assert_equal "with-invoice.test arve tasumise tähtaeg", email.subject
  end
end