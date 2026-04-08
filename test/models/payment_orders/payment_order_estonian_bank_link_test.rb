require 'test_helper'

class PaymentOrderEstonianBankLinkTest < ActiveSupport::TestCase
  IGNORED_IN_TEST = 'ignored-in-test'

  def setup
    super

    travel_to Time.zone.parse('2010-07-05 10:30:00 +0000')
    @user = users(:participant)
    @invoice = invoices(:orphaned)

    @bank_link = PaymentOrders::EstonianBankLink.create!(user: @user, status: :issued)
    @bank_link.return_url = 'https://example.test/return'
    @bank_link.invoices << @invoice
  end

  def teardown
    super
    travel_back
  end

  def with_currency
    original_find_by = Setting.method(:find_by)

    Setting.stub(:find_by, ->(args = {}) {
      if args.is_a?(Hash) && args[:code] == 'auction_currency'
        settings(:auction_currency)
      else
        original_find_by.call(args)
      end
    }) do
      yield
    end
  end

  def test_form_fields_includes_expected_keys_and_uses_mac_and_language
    @bank_link.stub(:seller_account, 'seller') do
      @bank_link.stub(:calc_mac, 'MAC') do
        with_currency do
          @user.update!(locale: 'et')
          fields = @bank_link.form_fields

          assert_equal PaymentOrders::EstonianBankLink::NEW_TRANSACTION_SERVICE_NUMBER, fields['VK_SERVICE']
          assert_equal PaymentOrders::EstonianBankLink::BANK_LINK_VERSION, fields['VK_VERSION']
          assert_equal 'seller', fields['VK_SND_ID']
          assert_equal @bank_link.id.to_s, fields['VK_STAMP']
          assert_equal 'MAC', fields['VK_MAC']
          assert_equal 'UTF-8', fields['VK_ENCODING']
          assert_equal PaymentOrders::EstonianBankLink::LANGUAGE_CODE_ET, fields['VK_LANG']
          assert_equal @bank_link.return_url, fields['VK_RETURN']
          assert_equal @bank_link.return_url, fields['VK_CANCEL']
        end
      end
    end
  end

  def test_form_fields_truncates_message_to_94_characters
    long_title = 'This is way longer than 94 characters ' * 5

    @invoice.stub(:title, long_title) do
      @bank_link.stub(:seller_account, 'seller') do
        @bank_link.stub(:calc_mac, 'MAC') do
          with_currency do
            fields = @bank_link.form_fields
            assert fields['VK_MSG'].length <= 94
          end
        end
      end
    end
  end

  def test_mark_invoice_as_paid_marks_payment_order_paid_when_success_notice_is_valid
    @bank_link.response = {
      'VK_SERVICE' => PaymentOrders::EstonianBankLink::SUCCESSFUL_PAYMENT_SERVICE_NUMBER,
      'VK_AMOUNT' => @invoice.total.to_d.to_s('F'),
      'VK_CURR' => settings(:auction_currency).retrieve,
      'VK_T_DATETIME' => '2018-04-01T00:30:00+0300',
      'VK_MAC' => IGNORED_IN_TEST
    }

    @invoice.stub(:mark_as_paid_at_with_payment_order, true) do
      @bank_link.stub(:verify_mac, true) do
        with_currency do
          assert @bank_link.mark_invoice_as_paid
          assert @bank_link.paid?
        end
      end
    end
  end

  def test_mark_invoice_as_paid_marks_payment_order_cancelled_when_cancel_notice_is_valid
    @bank_link.response = {
      'VK_SERVICE' => PaymentOrders::EstonianBankLink::CANCELLED_PAYMENT_SERVICE_NUMBER,
      'VK_MAC' => IGNORED_IN_TEST
    }

    @bank_link.stub(:verify_mac, true) do
      @bank_link.stub(:valid_success_notice?, false) do
      assert_not @bank_link.mark_invoice_as_paid
      assert @bank_link.cancelled?
      end
    end
  end

  def test_valid_successful_transaction_is_false_when_amount_is_invalid
    @bank_link.response = {
      'VK_SERVICE' => PaymentOrders::EstonianBankLink::SUCCESSFUL_PAYMENT_SERVICE_NUMBER,
      'VK_AMOUNT' => '999.99',
      'VK_CURR' => settings(:auction_currency).retrieve,
      'VK_MAC' => IGNORED_IN_TEST
    }

    @bank_link.stub(:verify_mac, true) do
      with_currency do
        assert_not @bank_link.send(:valid_successful_transaction?)
      end
    end
  end

  def test_valid_success_notice_is_false_when_mac_is_invalid
    @bank_link.response = { 'VK_MAC' => 'bad-mac' }

    @bank_link.stub(:verify_mac, false) do
      assert_not @bank_link.send(:valid_success_notice?)
    end
  end

  def test_valid_response_returns_false_for_unknown_service
    @bank_link.response = { 'VK_SERVICE' => '0000' }
    assert_not @bank_link.valid_response?
  end
end
