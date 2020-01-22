# frozen_string_literal: true

require 'test_helper'
class InvoicesHelperTest < ActionView::TestCase
  def setup; end

  def test_completed_payment_order_response_is_shown_properly
    response = paid_order_banklink_response
    assert_equal 'OK', fetch_errors_from_response(channel: 'SEB',
                                                  response: response.as_json)

    response = paid_everypay_banklink_respose
    assert_equal 'OK', fetch_errors_from_response(channel: 'EveryPay',
                                                  response: response.as_json)
  end

  def test_shows_errors_for_failed_payment_order
    response = paid_order_banklink_response.as_json
    response['VK_SERVICE'] = '1911'

    assert_includes(fetch_errors_from_response(channel: 'Swedbank',
                                               response: response),
                    "Bank responded with code #{response['VK_SERVICE']} (failed)")

    response = paid_everypay_banklink_respose.as_json
    response['transaction_result'] = 'failed'
    response['processing_errors'] = [{ code: 123, message: 'Stolen card; Lost card' }].as_json
    assert_includes(fetch_errors_from_response(channel: 'EveryPay',
                                               response: response),
                    'Stolen card; Lost card')
  end

  def paid_order_banklink_response
    {
      'VK_SERVICE': '1111',
      'VK_VERSION': '008',
      'VK_SND_ID': 'testvpos',
      'VK_REC_ID': 'seb',
      'VK_STAMP': 1,
      'VK_T_NO': '1',
      'VK_AMOUNT': '12.00',
      'VK_CURR': 'EUR',
      'VK_REC_ACC': '1234',
      'VK_REC_NAME': 'Eesti Internet',
      'VK_SND_ACC': '1234',
      'VK_SND_NAME': 'John Doe',
      'VK_REF': '',
      'VK_MSG': 'Order nr 1',
      'VK_T_DATETIME': '2018-04-01T00:30:00+0300',
      'VK_MAC': 'CZZvcptkxfuOxRR88JmT4N+Lw6Hs4xiQfhBWzVYldAcRTQbcB/lPf9MbJzBE4e1/HuslQgkdCFt5g1xW2lJwrVDBQTtP6DAHfvxU3kkw7dbk0IcwhI4whUl68/QCwlXEQTAVDv1AFnGVxXZ40vbm/aLKafBYgrirB5SUe8+g9FE=',
      'VK_ENCODING': 'UTF-8',
      'VK_LANG': 'ENG'
    }
  end

  def paid_everypay_banklink_respose
    {
      utf8: '✓',
      _method: 'put',
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
      hmac_fields: 'account_id,amount,api_username,cc_holder_name,cc_last_four_digits,cc_month,cc_type,cc_year,hmac_fields,nonce,order_reference,payment_reference,payment_state,timestamp,transaction_result',
      hmac: 'efac1c732835668cd86023a7abc140506c692f0d',
      invoice_id: '1'
    }
  end
end
