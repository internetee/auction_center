require 'test_helper'

class InvoicesIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:participant)
    @invoice = invoices(:payable)
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)

    stub_request(:patch, 'http://eis_billing_system:3000/api/v1/invoice/update_invoice_data')
      .to_return(status: 200, body: @message.to_json, headers: {})
  end

  def test_update_issued_invoice_to_paid
    assert @invoice.issued?

    incoming_params = {
      invoice: {
        invoice_number: @invoice.number,
        initiator: 'registry',
        payment_reference: '93b29d54ae08f7728e72ee3fe0e88855cd1d266912039d7d23fa2b54b7e1b349',
        transaction_amount: 120.0,
        status: 'paid',
        in_directo: false,
        everypay_response: {
          'some' => 'some'
        },
        sent_at_omniva: Time.zone.now - 10.minutes
      },
      status: 'paid'
    }

    put eis_billing_invoices_path, params: incoming_params

    @invoice.reload
    assert @invoice.paid?
  end

  def test_update_paid_invoice_to_issued
    @invoice.update(status: 'paid', paid_at: Time.zone.now) && @invoice.reload
    assert @invoice.paid?

    incoming_params = {
      invoice: {
        invoice_number: @invoice.number,
        initiator: 'registry',
        payment_reference: '93b29d54ae08f7728e72ee3fe0e88855cd1d266912039d7d23fa2b54b7e1b349',
        transaction_amount: 120.0,
        status: 'paid',
        in_directo: false,
        everypay_response: {
          'some' => 'some'
        },
        sent_at_omniva: Time.zone.now - 10.minutes
      },
      status: 'unpaid'
    }

    put eis_billing_invoices_path, params: incoming_params

    @invoice.reload
    assert @invoice.issued?
  end

  def test_update_issued_invoice_to_cancel
    assert @invoice.issued?

    incoming_params = {
      invoice: {
        invoice_number: @invoice.number,
        initiator: 'registry',
        payment_reference: '93b29d54ae08f7728e72ee3fe0e88855cd1d266912039d7d23fa2b54b7e1b349',
        transaction_amount: 120.0,
        status: 'paid',
        in_directo: false,
        everypay_response: {
          'some' => 'some'
        },
        sent_at_omniva: Time.zone.now - 10.minutes
      },
      status: 'cancelled'
    }

    put eis_billing_invoices_path, params: incoming_params

    @invoice.reload
    assert @invoice.cancelled?
  end

  def test_update_paid_invoice_to_cancel
    @invoice.update(status: 'paid', paid_at: Time.zone.now) && @invoice.reload
    assert @invoice.paid?

    incoming_params = {
      invoice: {
        invoice_number: @invoice.number,
        initiator: 'registry',
        payment_reference: '93b29d54ae08f7728e72ee3fe0e88855cd1d266912039d7d23fa2b54b7e1b349',
        transaction_amount: 120.0,
        status: 'paid',
        in_directo: false,
        everypay_response: {
          'some' => 'some'
        },
        sent_at_omniva: Time.zone.now - 10.minutes
      },
      status: 'cancelled'
    }

    put eis_billing_invoices_path, params: incoming_params

    @invoice.reload
    assert @invoice.cancelled?
  end

  def test_cannot_change_status_from_cancelled_to_paid
    @invoice.update(status: 'cancelled', paid_at: nil) && @invoice.reload
    assert @invoice.cancelled?

    incoming_params = {
      invoice: {
        invoice_number: @invoice.number,
        initiator: 'registry',
        payment_reference: '93b29d54ae08f7728e72ee3fe0e88855cd1d266912039d7d23fa2b54b7e1b349',
        transaction_amount: 120.0,
        status: 'paid',
        in_directo: false,
        everypay_response: {
          'some' => 'some'
        },
        sent_at_omniva: Time.zone.now - 10.minutes
      },
      status: 'paid'
    }

    put eis_billing_invoices_path, params: incoming_params

    assert_equal JSON.parse(response.body)["error"]["base"], ["Invoice is not payable"]

    @invoice.reload
    assert @invoice.cancelled?
  end

  def test_change_from_cancel_to_unpaid
    @invoice.update(status: 'cancelled', paid_at: nil) && @invoice.reload
    assert @invoice.cancelled?

    incoming_params = {
      invoice: {
        invoice_number: @invoice.number,
        initiator: 'registry',
        payment_reference: '93b29d54ae08f7728e72ee3fe0e88855cd1d266912039d7d23fa2b54b7e1b349',
        transaction_amount: 120.0,
        status: 'paid',
        in_directo: false,
        everypay_response: {
          'some' => 'some'
        },
        sent_at_omniva: Time.zone.now - 10.minutes
      },
      status: 'unpaid'
    }

    put eis_billing_invoices_path, params: incoming_params

    @invoice.reload
    assert @invoice.issued?
  end
end