require 'test_helper'

class PaymentOrderEveryPayTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.zone.parse('2018-04-01 00:30:00 +0000')
    invoice = invoices(:orphaned)
    user = users(:participant)

    @every_pay = PaymentOrders::EveryPay.new(status: :issued, invoice: invoice,
                                             user: user)
  end

  def teardown
    super

    travel_back
  end

  def test_form_fields
    expected_fields = {
      api_username: 'api_user',
      account_id: 'EUR3D1',
      timestamp: '1522542600',
      amount: '12.00',
      transaction_type: 'charge',
      hmac_fields: 'account_id,amount,api_username,callback_url,customer_url,hmac_fields,nonce,order_reference,timestamp,transaction_type'
    }
    form_fields = @every_pay.form_fields
    expected_fields.each do |k, v|
      assert_equal(v, form_fields[k])
    end
  end
end
