require "test_helper"

class PaymentStatusTest < ActionDispatch::IntegrationTest
  setup do
    @invoice = invoices(:payable)
    @payment_order = payment_orders(:issued)
  end

  # def test_update_payment_status_should_create_succesfully_billing_instaces
  #   invoice_n = Invoice.order(number: :desc).last.number
  #   stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator')
  #     .to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}", headers: {})
  #   stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/invoice_number_generator')
  #     .to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}", headers: {})

  #   payload = {
  #     "order_reference" => @invoice.number,
  #     "payment_reference" => "some_ref"
  #   }

  #   put eis_billing_payment_status_path, params: payload, headers: { 'HTTP_COOKIE' => 'session=participant' }

  #   assert_response :ok
  # end
end
