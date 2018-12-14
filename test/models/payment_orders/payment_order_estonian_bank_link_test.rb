# encoding: UTF-8
require 'test_helper'

class PaymentOrderEstonianBankLinkTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
    @payable_invoice = invoices(:payable)
    @orphaned_invoice = invoices(:orphaned)
    @user = users(:participant)

    @new_bank_link = PaymentOrders::SEB.new(invoice: @orphaned_invoice)
    @new_bank_link.return_url = 'return.url'

    create_completed_bank_link
    create_cancelled_bank_link
  end


  def teardown
    super

    travel_back
  end

  def test_form_fields
    expected_response = {
      'VK_SERVICE': '1012',
      'VK_VERSION': '008',
      'VK_SND_ID': 'testvpos',
      'VK_STAMP': 1,
      'VK_AMOUNT': '12.00',
      'VK_CURR': 'EUR',
      'VK_REF': '',
      'VK_MSG': 'Invoice no. 1',
      'VK_RETURN': 'return.url',
      'VK_CANCEL': 'return.url',
      'VK_DATETIME': '2010-07-05T10:30:00+0000',
      'VK_MAC': 'a947QsWS7rkBhGqtX5WHDStSkYvXVbYKo9j21UY6cxEaIJ4F6KgQXCAMaYVsyes/OQdPwqHDosvS9TQ9jSV/enWzKhFdwEgF1M4iboa0bfwydbiZ14AUQiIB32c6kBtp/2Ug2Hena0LGmTlyrhHv3+gZTitiA/1nVChKN1wnNNk=',
      'VK_ENCODING': 'UTF-8',
      'VK_LANG': 'ENG'
    }.with_indifferent_access

    @orphaned_invoice.stub(:number, 1) do
      assert_equal(expected_response, @new_bank_link.form_fields)
    end
  end

  def test_completed_bank_link
    assert(@completed_bank_link.valid_response?)
    assert(@completed_bank_link.mark_invoice_as_paid)

    assert_equal(Invoice.statuses[:paid], @completed_bank_link.invoice.status)
    assert(@completed_bank_link.invoice.paid_at)
  end

  def test_cancelled_bank_link
    assert(@cancelled_bank_link.valid_response?)
    refute(@cancelled_bank_link.mark_invoice_as_paid)
    assert_equal(PaymentOrder.statuses[:cancelled], @cancelled_bank_link.status)

    assert_equal(Invoice.statuses[:issued], @cancelled_bank_link.invoice.status)
    refute(@cancelled_bank_link.invoice.paid_at)
  end

  def test_config_namespace
    assert_equal('swedbank', PaymentOrders::Swedbank.config_namespace_name)
    assert_equal('seb', PaymentOrders::SEB.config_namespace_name)
    assert_equal('lhv', PaymentOrders::LHV.config_namespace_name)
  end

  def create_cancelled_bank_link
    params = {
      'VK_SERVICE': '1911',
      'VK_VERSION': '008',
      'VK_SND_ID': 'testvpos',
      'VK_REC_ID': 'seb',
      'VK_STAMP': 1,
      'VK_REF': '',
      'VK_MSG': 'Order nr 1',
      'VK_MAC': 'PElE2mYXXN50q2UBvTuYU1rN0BmOQcbafPummDnWfNdm9qbaGQkGyOn0XaaFGlrdEcldXaHBbZKUS0HegIgjdDfl2NOk+wkLNNH0Iu38KzZaxHoW9ga7vqiyKHC8dcxkHiO9HsOnz77Sy/KpWCq6cz48bi3fcMgo+MUzBMauWoQ=',
      'VK_ENCODING': 'UTF-8',
      'VK_LANG': 'ENG'
    }

    @cancelled_bank_link = PaymentOrders::SEB.new(invoice: @orphaned_invoice, response: params,
                                                  user: @user)
  end

  def create_completed_bank_link
    params = {
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

    @completed_bank_link = PaymentOrders::SEB.new(invoice: @orphaned_invoice, response: params,
                                                  user: @user)
  end
end
