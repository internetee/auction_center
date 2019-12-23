require 'test_helper'

class InvoiceCancellationTest < ActiveSupport::TestCase
  def setup
    super

    @result = results(:with_invoice)
    @company_billing_profile = billing_profiles(:company)
    @user = users(:participant)

    @overdue_invoice = invoices(:payable)
    @new_invoice = prefill_invoice
  end

  def teardown
    super

    clear_email_deliveries
  end

  def prefill_invoice
    invoice = Invoice.new
    invoice.result = @result
    invoice.billing_profile = @company_billing_profile
    invoice.user = @user
    invoice.issue_date = Time.zone.today
    invoice.due_date = Time.zone.today + Setting.find_by(code: 'payment_term').retrieve
    invoice.cents = 1000

    invoice
  end

  def test_instance_initialization
    invoice_cancellation = InvoiceCancellation.new(@overdue_invoice)

    assert_equal(@overdue_invoice, invoice_cancellation.invoice)
    assert_equal(@result, invoice_cancellation.result)
    assert_equal(@user, invoice_cancellation.user)
    assert_equal('with-invoice.test', invoice_cancellation.domain_name)
  end

  def test_cancel_sets_the_status_on_results
    invoice_cancellation = InvoiceCancellation.new(@overdue_invoice)
    assert(invoice_cancellation.cancel)

    assert_equal(Invoice.statuses[:cancelled], @overdue_invoice.status)
    assert_equal(Result.statuses[:payment_not_received], @overdue_invoice.result.status)
  end

  def test_cancel_does_nothing_when_invoice_is_not_overdue
    invoice_cancellation = InvoiceCancellation.new(@new_invoice)
    assert_not(invoice_cancellation.cancel)

    assert_equal(Invoice.statuses[:issued], @new_invoice.status)
  end

  def test_cancel_bans_the_offender
    invoice_cancellation = InvoiceCancellation.new(@overdue_invoice)
    assert(invoice_cancellation.cancel)

    @user.reload

    assert(@user.banned?)
  end

  def test_cancel_sends_ban_notice
    invoice_cancellation = InvoiceCancellation.new(@overdue_invoice)
    assert(invoice_cancellation.cancel)

    assert_not(ActionMailer::Base.deliveries.empty?)
    last_email = ActionMailer::Base.deliveries.last

    assert_equal('Participation in with-invoice.test auction prohibited', last_email.subject)
    assert_equal(['user@auction.test'], last_email.to)
  end
end
