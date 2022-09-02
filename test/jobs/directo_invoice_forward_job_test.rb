# frozen_string_literal: true

require 'test_helper'

class DirectoInvoiceForwardJobTest < ActiveJob::TestCase
  def setup
    super
    @directo_enabled = settings(:directo_integration_enabled)
    @directo_api_url = settings(:directo_api_url)
    @invoice = invoices(:payable)
  end

  def test_collection_of_empty_paid_invoices_returns_nil
    assert Invoice.where(status: 'paid').empty?

    assert_nil DirectoInvoiceForwardJob.perform_now
  end

  def test_collection_of_paid_invoice_returns_true
    @invoice.mark_as_paid_at(Time.zone.now)
    @invoice.reload

    assert DirectoInvoiceForwardJob.perform_now
  end

  def test_job_cannot_contain_paid_invoices_what_have_been_in_directo
    @invoice.mark_as_paid_at(Time.zone.now)
    @invoice.update!(in_directo: true)
    @invoice.reload

    assert_nil DirectoInvoiceForwardJob.perform_now
  end

  def test_job_runnability_is_determined_by_setting_value
    assert DirectoInvoiceForwardJob.needs_to_run?

    @directo_enabled.update!(value: 'false')
    assert !DirectoInvoiceForwardJob.needs_to_run?
  end
end
