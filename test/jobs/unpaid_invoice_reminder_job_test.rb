require 'test_helper'

class UnpaidInvoiceReminderJobTest < ActiveJob::TestCase
  def setup
    super

    @invoice = invoices(:payable)
    travel_to(@invoice.due_date - Setting.invoice_reminder_in_days)
    clear_email_deliveries
  end

  def teardown
    super

    travel_back
    clear_email_deliveries
  end

  def test_emails_are_sent_according_to_setting
    perform_enqueued_jobs do
      UnpaidInvoiceReminderJob.perform_now
    end

    last_email = ActionMailer::Base.deliveries.last
    assert_equal('with-invoice.test invoice due date', last_email.subject)
    assert_equal(['user@auction.test'], last_email.to)
  end

  def test_emails_are_not_sent_when_invoice_is_cancelled
    @invoice.cancelled!

    assert_equal('cancelled', @invoice.status)

    perform_enqueued_jobs do
      UnpaidInvoiceReminderJob.perform_now
    end

    last_email = ActionMailer::Base.deliveries.last
    refute last_email
  end

  def test_emails_are_not_sent_when_invoice_is_paid
    @invoice.mark_as_paid_at(Time.zone.now)

    assert_equal('paid', @invoice.status)

    perform_enqueued_jobs do
      UnpaidInvoiceReminderJob.perform_now
    end

    last_email = ActionMailer::Base.deliveries.last
    refute last_email
  end
end
