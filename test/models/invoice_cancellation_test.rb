require 'test_helper'

class InvoiceCancellationTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    super

    @result = results(:with_invoice)
    @company_billing_profile = billing_profiles(:company)
    @user = users(:participant)

    @overdue_invoice = invoices(:payable)
    @new_invoice = prefill_invoice

    stub_request(:patch, 'http://eis_billing_system:3000/api/v1/invoice/update_invoice_data')
      .to_return(status: 200, body: @message.to_json, headers: {})
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
    message = {
      message: 'Status updated'
    }
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_status")
      .to_return(status: 200, body: message.to_json, headers: {})

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
    message = {
      message: 'Status updated'
    }
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_status")
      .to_return(status: 200, body: message.to_json, headers: {})

    invoice_cancellation = InvoiceCancellation.new(@overdue_invoice)
    assert(invoice_cancellation.cancel)

    @user.reload

    assert(@user.banned?)
  end

  def test_cancel_sends_ban_notice
    message = {
      message: 'Status updated'
    }
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_status")
      .to_return(status: 200, body: message.to_json, headers: {})

    invoice_cancellation = InvoiceCancellation.new(@overdue_invoice)
    perform_enqueued_jobs do
      assert(invoice_cancellation.cancel)
    end

    assert_not(ActionMailer::Base.deliveries.empty?)
    last_email = ActionMailer::Base.deliveries.last

    assert_equal('Participation in with-invoice.test auction prohibited', last_email.subject)
    assert_equal(['user@auction.test'], last_email.to)
  end
end
