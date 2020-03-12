require 'test_helper'

# https://www.lhv.ee/images/docs/Bank_Link_Technical_Specification-EN.pdf
# All Estonian banks share the same specification

class PaymentOrderEstonianBankLinkTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    @payable_invoice = invoices(:payable)
    @orphaned_invoice = invoices(:orphaned)
    @user = users(:participant)

    @new_bank_link = PaymentOrders::SEB.new(invoices: [@orphaned_invoice])
    @new_bank_link.return_url = 'return.url'

    create_completed_bank_link
    create_cancelled_bank_link
  end

  def teardown
    super

    travel_back
    I18n.locale = I18n.default_locale
  end

  def test_form_fields
    @orphaned_invoice.cents = Money.from_amount(1000.00, Setting.find_by(code: 'auction_currency').retrieve).cents
    assert_equal Money.from_amount(1200.00, Setting.find_by(code: 'auction_currency').retrieve), @orphaned_invoice.total

    expected_fields = {
      'VK_SERVICE': '1012',
      'VK_VERSION': '008',
      'VK_SND_ID': 'testvpos',
      'VK_STAMP': '1',
      'VK_AMOUNT': '1200.00',
      'VK_CURR': 'EUR',
      'VK_REF': '',
      'VK_MSG': 'Invoice no. 1',
      'VK_RETURN': 'return.url',
      'VK_CANCEL': 'return.url',
      'VK_DATETIME': '2010-07-05T10:30:00+0000',
      'VK_MAC': 'zdQUhEzozyt6IVgB5+8oTxm1lj2xswIKYI/htHRVZ/TLfi4fa3boBi1Jk4SpY3dPaDMsxHqlnhwv913VVgvpwJZW0YEN1o4pPztvLvZDlNgu+XZyi8c5SluYSeB9CijbFGQz0oOLZ4rHlfYf5S5ALA/x1/NVdtJURwUrFnWBlYs=',
      'VK_ENCODING': 'UTF-8',
      'VK_LANG': 'ENG',
    }.with_indifferent_access

    @orphaned_invoice.stub(:number, 1) do
      @new_bank_link.id = 1
      form_fields = @new_bank_link.form_fields

      expected_fields.each do |k, v|
        assert_equal(v, form_fields[k])
      end
    end
  end

  def test_channel
    assert_equal('SEB', @new_bank_link.channel)
  end

  def test_form_fields_with_estonian_locale
    I18n.locale = 'et'

    I18n.stub(:t, 'Invoice no. 1') do
      test_form_fields
    end
  end

  def test_user_locale_is_mapped_to_vk_lang
    @new_bank_link.user = @user
    @orphaned_invoice.cents = Money.from_amount(1234.56, Setting.find_by(code: 'auction_currency').retrieve).cents
    assert_equal Money.from_amount(1481.47, Setting.find_by(code: 'auction_currency').retrieve), @orphaned_invoice.total
    @user.update!(locale: :et)

    expected_fields = {
      'VK_SERVICE': '1012',
      'VK_VERSION': '008',
      'VK_SND_ID': 'testvpos',
      'VK_STAMP': '1',
      'VK_AMOUNT': '1481.47',
      'VK_CURR': 'EUR',
      'VK_REF': '',
      'VK_MSG': 'Invoice no. 1',
      'VK_RETURN': 'return.url',
      'VK_CANCEL': 'return.url',
      'VK_DATETIME': '2010-07-05T10:30:00+0000',
      'VK_MAC': 'E+R5WbTfdziFVR2bcgsH/Mapdz5JRv8P2rKhgdoSUQbjmnQ/vssXF/ZEVjU5fUXy+FI6w6Y33bJK6GHRUPhjbsKPChCPCGofe4gGjmFYyA5ODtQEpD29tcNii6K5gLsytmRI0k6/igXTMZOErY0K9zgJbxAPENh//iocxAjCjHs=',
      'VK_ENCODING': 'UTF-8',
      'VK_LANG': 'EST',
    }.with_indifferent_access

    @orphaned_invoice.stub(:number, 1) do
      @new_bank_link.id = 1
      form_fields = @new_bank_link.form_fields

      expected_fields.each do |k, v|
        assert_equal(v, form_fields[k])
      end
    end
  end

  def test_completed_bank_link
    assert(@completed_bank_link.valid_response?)
    assert(@completed_bank_link.mark_invoice_as_paid)

    assert(@completed_bank_link.invoices.all? { |invoice| invoice.status == Invoice.statuses[:paid] })
    assert(@completed_bank_link.invoices.all? { |invoice| invoice.paid_at.present? })
  end

  def test_cancelled_bank_link
    assert(@cancelled_bank_link.valid_response?)
    assert_not(@cancelled_bank_link.mark_invoice_as_paid)
    assert_equal(PaymentOrder.statuses[:cancelled], @cancelled_bank_link.status)

    assert(@cancelled_bank_link.invoices.all? { |invoice| invoice.status == Invoice.statuses[:issued] })
    assert_not(@cancelled_bank_link.invoices.all? { |invoice| invoice.paid_at.present? })
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
      'VK_LANG': 'ENG',
    }

    @cancelled_bank_link = PaymentOrders::SEB.new(invoices: [@orphaned_invoice], response: params,
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
      'VK_LANG': 'ENG',
    }

    @completed_bank_link = PaymentOrders::SEB.new(invoices: [@orphaned_invoice], response: params,
                                                  user: @user)
  end
end
