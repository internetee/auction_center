require 'test_helper'

class PaymentOrdersTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  include Devise::Test::IntegrationHelpers

  def setup
    @invoice = invoices(:payable)
    @payment_order = payment_orders(:issued)
  end

  def test_response_from_callback_endpoint
    post callback_payment_order_path(@payment_order.uuid)
    response_json = JSON.parse(response.body)

    assert_equal({ 'status' => 'ok' }, response_json)
    assert_equal(200, response.status)
  end

  def request_params
    {
      authenticity_token: 'OnA69vbccQtMt3C9wxEWigs5Gpf/7z+NoxRCMkFPlTvaATs8+OgMKF1I4B2f+vuK37zCgpWZaWWtyuslRRSwkw==',
      nonce: '392f2d7748bc8cb0d14f263ebb7b8932',
      timestamp: '1524136727',
      api_username: 'ca8d6336dd750ddb',
      transaction_result: 'completed',
      payment_reference: 'fd5d27b59a1eb597393cd5ff77386d6cab81ae05067e18d530b10f3802e30b56',
      payment_state: 'settled',
      amount: '12.00',
      order_reference: 'e468a2d59a731ccc546f2165c3b1a6',
      account_id: 'EUR3D1',
      cc_type: 'master_card',
      cc_last_four_digits: '0487',
      cc_month: '10',
      cc_year: '2018',
      cc_holder_name: 'John Doe',
      transaction_time: (Time.zone.now - 1.minute).to_s,
      hmac_fields: 'account_id,amount,api_username,cc_holder_name,cc_last_four_digits,cc_month,cc_type,cc_year,hmac_fields,nonce,order_reference,payment_reference,payment_state,timestamp,transaction_result',
      hmac: 'efac1c732835668cd86023a7abc140506c692f0d',
      invoice_id: '1',
    }
  end
end
