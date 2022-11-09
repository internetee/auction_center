require 'test_helper'

class PaymentStatusTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @invoice = invoices(:payable)
    @user = users(:participant)
    @invoiceable_result = results(:expired_participant)
    @payment_order = payment_orders(:issued)
    @payment_order.update(invoice_id: @invoice.id)
    @payment_order.reload
    @auction = auctions(:english)

    sign_in users(:participant)
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
    message = {
      message: '12345'
    }

    invoice_n = Invoice.order(number: :desc).last.number
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_number_generator")
      .to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}", headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator")
      .to_return(status: 200, body: "{\"everypay_link\":\"http://link.test\"}", headers: {})

    stub_request(:put, "http://registry:3000/eis_billing/e_invoice_response").
      to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}, {\"date\":\"#{Time.zone.now-10.minutes}\"}", headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/e_invoice/e_invoice").
      to_return(status: 200, body: "", headers: {})
  end

  def test_successfully_response_should_update_invoice_status_to_paid
    payload = {
      order_reference: @invoice.number.to_s,
      transaction_time: Time.zone.now - 2.minute,
      standing_amount: @invoice.total,
      payment_state: 'settled',
      invoice_number_collection: nil
    }

    assert_nil @invoice.paid_at

    put eis_billing_payment_status_path, params: payload, headers: { 'HTTP_COOKIE' => 'session=customer' }

    @invoice.reload

    assert_not_nil @invoice.paid_at
    assert_response :ok
  end

  def test_successfully_response_should_update_multiple_invoices_status_to_paid
    invoice_from_result = Invoice.create_from_result(@invoiceable_result.id)

    payload = {
      order_reference: nil,
      transaction_time: Time.zone.now - 2.minute,
      standing_amount: @invoice.total + invoice_from_result.total,
      payment_state: 'settled',
      invoice_number_collection: [{number: invoice_from_result.number.to_s }, { number: @invoice.number.to_s }]
    }

    assert_nil @invoice.paid_at
    assert_nil invoice_from_result.paid_at

    put eis_billing_payment_status_path, params: payload, headers: { 'HTTP_COOKIE' => 'session=customer' }

    @invoice.reload
    invoice_from_result.reload

    assert_not_nil @invoice.paid_at
    assert_not_nil invoice_from_result.paid_at
    assert_response :ok
  end

  def test_should_allow_user_to_participate_if_deposit_was_added
    @auction.update(enable_deposit: true, requirement_deposit_in_cents: 50000)
    @auction.reload

    payload = {
      domain_name: @auction.domain_name,
      user_uuid: @user.uuid,
      user_email: @user.email,
      transaction_amount: 500.0,
      description: 'deposit'
    }

    refute @auction.allow_to_set_bid?(@user)

    put eis_billing_payment_status_path, params: payload, headers: { 'HTTP_COOKIE' => 'session=customer' }

    @user.reload

    assert @auction.allow_to_set_bid?(@user)
  end
end
