require 'test_helper'

class MontonioControllerTest < ActionDispatch::IntegrationTest
  setup do
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
    stub_request(:patch, 'http://eis_billing_system:3000/api/v1/invoice/update_invoice_data')
      .to_return(status: 200, body: '{"message":"ok"}', headers: {})

    @invoice = invoices(:payable)
    @invoice.update!(payment_link: 'https://pay.montonio.com/abc-123')
  end

  def test_callback_redirects_to_invoices_payment_state
    get montonio_callback_path

    assert_redirected_to invoices_path(state: 'payment')
  end

  def test_callback_does_not_settle_the_invoice_from_the_order_token
    get montonio_callback_path, params: { 'order-token' => 'tampered.jwt.token',
                                          'order_reference' => @invoice.number,
                                          'payment_reference' => 'abc-123' }

    assert_redirected_to invoices_path(state: 'payment')

    @invoice.reload
    assert_nil @invoice.paid_at
    assert_equal 'issued', @invoice.status
  end
end
