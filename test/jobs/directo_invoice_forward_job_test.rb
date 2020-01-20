# frozen_string_literal: true

require 'test_helper'

class DirectoInvoiceForwardJobTest < ActiveJob::TestCase
  def setup
    super
    @directo_enabled = settings(:directo_integration_enabled)
    @directo_api_url = settings(:directo_api_url)
    @invoice = invoices(:payable)
  end

  def test_delivered_invoices_are_marked_as_synced
    @invoice.mark_as_paid_at(Time.now)
    @invoice.update!(number: 1337)

    xml = '<?xml version="1.0" encoding="UTF-8"?><results><Result Type="0" Desc="OK" docid="1337" doctype="ARVE" submit="Invoices"/></results>'
    stub_request(:post, @directo_api_url.retrieve)
      .to_return(body: xml, status: 200, headers: {})

    DirectoInvoiceForwardJob.perform_now

    @invoice.reload
    assert @invoice.in_directo
  end

  def test_failed_invoices_are_not_marked_as_synced
    @invoice.mark_as_paid_at(Time.now)
    @invoice.update!(number: 1337)

    xml = '<?xml version="1.0" encoding="UTF-8"?><results><Result Type="1" Desc="Failed" docid="1337" doctype="ARVE" submit="Invoices"/></results>'
    stub_request(:post, @directo_api_url.retrieve)
      .to_return(body: xml, status: 200, headers: {})

    DirectoInvoiceForwardJob.perform_now

    @invoice.reload
    assert_not @invoice.in_directo
  end

  def test_job_runnability_is_determined_by_setting_value
    assert DirectoInvoiceForwardJob.needs_to_run?

    @directo_enabled.update!(value: 'false')
    assert !DirectoInvoiceForwardJob.needs_to_run?
  end
end
