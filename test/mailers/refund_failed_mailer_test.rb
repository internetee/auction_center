require 'test_helper'
require 'support/mock_summary_report'

class RefundFailedMailerTest < ActionMailer::TestCase
  def setup
    super

    @time = Time.parse('2010-07-05 10:30 +0000').in_time_zone
    travel_to @time

    @participant = users(:participant)
  end

  def test_send_email_to_admins
    admin_emails = User.where(roles: ["administrator"]).pluck(:email)
    auction = auctions(:english)
    error_message = {
      "error" => {
        "code" => 4037,
        "message" => "Open banking payments cannot be refunded"
      }
    }
    mailer = InvoiceMailer.refund_failed(admin_emails, auction, @participant, error_message).deliver_now

    assert_equal mailer.to, admin_emails
    assert_equal mailer.subject, 'Deposit refund failed'
  end
end