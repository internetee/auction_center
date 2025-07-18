require 'test_helper'
require 'ostruct'

class LHVConnectTransactionsIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    stub_request(:any, /eis_billing_system/)
      .to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})

    @invoice = invoices(:orphaned)
    @user = users(:participant)

    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)

    clear_email_deliveries
    
    sign_in @user
  end

  def test_should_mark_unpaid_invoice_as_paid
    @user.update!(reference_no: '2199812') && @user.reload

    assert_equal '2199812', @user.reference_no
    assert_equal @user.invoices.count, 1

    invoice = @user.invoices.first

    assert_equal invoice.total, Money.from_amount(10.00, 'EUR')
    assert_equal invoice.status, 'issued'

    test_transaction_1 = { amount: 10.00,
                           currency: 'EUR',
                           date: Time.zone.today,
                           payment_reference_number: '2199812',
                           payment_description: 'description 2199812'
                          }

    lhv_transactions = []
    lhv_transactions << test_transaction_1

    assert_difference 'BankStatement.count', 1 do
      assert_difference 'BankTransaction.count', 1 do
        post eis_billing_lhv_connect_transactions_path, params: { '_json' => JSON.parse(lhv_transactions.to_json) },
                                                        headers: { 'HTTP_COOKIE' => 'session=api_bestnames' }
      end
    end

    @user.reload && invoice.reload

    assert_equal '2199812', @user.reference_no
    assert_equal @user.invoices.count, 1

    invoice = @user.invoices.first

    assert_equal invoice.total, Money.from_amount(10.00, 'EUR')
    assert_equal invoice.status, 'paid'
  end

  def test_should_inform_admin_about_no_matches_transactions
    @user.update!(reference_no: '2199812') && @user.reload

    assert_equal '2199812', @user.reference_no
    assert_equal @user.invoices.count, 1

    invoice = @user.invoices.first

    assert_equal invoice.total, Money.from_amount(10.00, 'EUR')
    assert_equal invoice.status, 'issued'

    test_transaction_1 = OpenStruct.new(amount: 20.00,
                                        currency: 'EUR',
                                        date: Time.zone.today,
                                        payment_reference_number: '2199812',
                                        payment_description: 'description 2199812')


    lhv_transactions = []
    lhv_transactions << test_transaction_1

    assert_difference 'BankStatement.count', 1 do
      assert_difference 'BankTransaction.count', 1 do
        post eis_billing_lhv_connect_transactions_path, params: { '_json' => JSON.parse(lhv_transactions.to_json) },
                                                        headers: { 'HTTP_COOKIE' => 'session=api_bestnames' }
      end
    end

    @user.reload && invoice.reload

    assert_equal '2199812', @user.reference_no
    assert_equal @user.invoices.count, 1

    invoice = @user.invoices.first

    assert_equal invoice.total, Money.from_amount(10.00, 'EUR')
    assert_equal invoice.status, 'issued'
    assert assert_enqueued_emails 1
  end

  def test_should_not_mark_paid_invoices_as_paid_again
    @user.update!(reference_no: '2199812') && @user.reload

    assert_equal '2199812', @user.reference_no
    assert_equal @user.invoices.count, 1

    invoice = @user.invoices.first

    assert_equal invoice.total, Money.from_amount(10.00, 'EUR')

    payment_order = invoice.payment_orders.where(status: 'paid').first

    invoice.mark_as_paid_at_with_payment_order(Time.zone.now, payment_order) && invoice.reload

    assert_equal invoice.status, 'paid'

    test_transaction_1 = OpenStruct.new(amount: 10.00,
                                        currency: 'EUR',
                                        date: Time.zone.today,
                                        payment_reference_number: '2199812',
                                        payment_description: 'description 2199812')


    lhv_transactions = []
    lhv_transactions << test_transaction_1

    assert_difference 'BankStatement.count', 1 do
      assert_difference 'BankTransaction.count', 1 do
        post eis_billing_lhv_connect_transactions_path, params: { '_json' => JSON.parse(lhv_transactions.to_json) },
                                                        headers: { 'HTTP_COOKIE' => 'session=api_bestnames' }
      end
    end

    @user.reload && invoice.reload

    assert_equal '2199812', @user.reference_no
    assert_equal @user.invoices.count, 1

    invoice = @user.invoices.first

    assert_equal invoice.total, Money.from_amount(10.00, 'EUR')
    assert_equal invoice.status, 'paid'
    assert assert_enqueued_emails 1
  end

  def test_should_not_mark_cancelled_invoices_as_paid
    @user.update!(reference_no: '2199812') && @user.reload

    assert_equal '2199812', @user.reference_no
    assert_equal @user.invoices.count, 1

    invoice = @user.invoices.first

    assert_equal invoice.total, Money.from_amount(10.00, 'EUR')
    invoice.cancelled! && invoice.reload

    assert_equal invoice.status, 'cancelled'

    test_transaction_1 = OpenStruct.new(amount: 10.00,
                                        currency: 'EUR',
                                        date: Time.zone.today,
                                        payment_reference_number: '2199812',
                                        payment_description: 'description 2199812')


    lhv_transactions = []
    lhv_transactions << test_transaction_1

    assert_difference 'BankStatement.count', 1 do
      assert_difference 'BankTransaction.count', 1 do
        post eis_billing_lhv_connect_transactions_path, params: { '_json' => JSON.parse(lhv_transactions.to_json) },
                                                        headers: { 'HTTP_COOKIE' => 'session=api_bestnames' }
      end
    end

    @user.reload && invoice.reload

    assert_equal '2199812', @user.reference_no
    assert_equal @user.invoices.count, 1

    invoice = @user.invoices.first

    assert_equal invoice.total, Money.from_amount(10.00, 'EUR')
    assert_equal invoice.status, 'cancelled'
    assert assert_enqueued_emails 1
  end
end
