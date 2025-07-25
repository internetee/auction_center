require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def setup
    super

    @result = results(:expired_participant)
    @not_sold_result = results(:without_offers_nobody)
    @user = users(:participant)
    @orphan_billing_profile = billing_profiles(:orphaned)
    @company_billing_profile = billing_profiles(:company)
    @payable_invoice = invoices(:payable)
    @orphaned_invoice = invoices(:orphaned)
    @english = auctions(:english)

    invoice_n = Invoice.order(number: :desc).last.number
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_number_generator")
      .to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}", headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator")
      .to_return(status: 200, body: "{\"everypay_link\":\"http://link.test\"}", headers: {})

    stub_request(:put, "http://registry:3000/eis_billing/e_invoice_response").
      to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}, {\"date\":\"#{Time.zone.now-10.minutes}\"}", headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/e_invoice/e_invoice").
      to_return(status: 200, body: "", headers: {})

    stub_request(:patch, 'http://eis_billing_system:3000/api/v1/invoice/update_invoice_data')
      .to_return(status: 200, body: @message.to_json, headers: {})
  end

  def teardown
    super

    travel_back
  end

  def test_price_is_a_money_object
    invoice = Invoice.new(cents: 1000)

    assert_equal(Money.new(1000, Setting.find_by(code: 'auction_currency').retrieve), invoice.price)

    invoice.cents = nil
    assert_equal(Money.new(0, Setting.find_by(code: 'auction_currency').retrieve), invoice.price)
  end

  def test_required_fields
    invoice = Invoice.new
    assert_not(invoice.valid?)

    assert_equal(['must exist'], invoice.errors[:result], invoice.errors.full_messages)
    assert_equal(["can't be blank"], invoice.errors[:billing_profile], invoice.errors.full_messages)
    assert_equal(["can't be blank"], invoice.errors[:user_id], invoice.errors.full_messages)
    assert_equal(["can't be blank"], invoice.errors[:issue_date], invoice.errors.full_messages)
    assert_equal(["can't be blank"], invoice.errors[:due_date], invoice.errors.full_messages)

    invoice.result = @result
    invoice.billing_profile = @company_billing_profile
    invoice.user = @user
    invoice.issue_date = Time.zone.today
    invoice.due_date = Time.zone.today + Setting.find_by(code: 'payment_term').retrieve
    invoice.cents = 1000

    assert(invoice.valid?)
  end

  def test_cents_must_be_an_integer
    invoice = prefill_invoice
    invoice.cents = 10.00

    assert_not(invoice.valid?)

    assert_equal(['must be an integer'], invoice.errors[:cents])
  end

  def test_filename
    assert_match(/invoice-no-\d+/, @payable_invoice.filename)

    invoice = prefill_invoice
    assert_not(invoice.filename)
  end

  def test_cents_must_be_positive
    invoice = prefill_invoice
    invoice.cents = -1000

    assert_not(invoice.valid?)

    assert_equal(['must be greater than or equal to 0'], invoice.errors[:cents])
  end

  def test_user_must_be_the_same_as_the_one_on_billing_or_nil
    invoice = Invoice.new
    invoice.result = @result
    invoice.billing_profile = @orphan_billing_profile
    invoice.user = @user

    assert_not(invoice.valid?)
    assert_equal(['must belong to the same user as invoice'], invoice.errors[:billing_profile])
  end

  def test_user_id_must_be_present_on_creation
    mock = Minitest::Mock.new
    def mock.authorized; true; end

    clazz = EisBilling::BaseController.new

    clazz.stub :authorized, mock do
      invoice = prefill_invoice
      invoice.user = nil
      assert_not(invoice.valid?(:create))

      invoice.user = @user
      assert(invoice.valid?(:create))

      invoice.save
      invoice.user = nil

      assert(invoice.valid?)
    end
  end

  def test_default_status_is_issued
    invoice = prefill_invoice

    assert_equal('issued', invoice.status)
  end

  def test_paid_at_must_be_present_when_status_is_paid
    @payable_invoice.status = :paid

    assert_not(@payable_invoice.valid?)
    assert_equal(["can't be blank"], @payable_invoice.errors[:paid_at])
  end

  def test_create_from_result_only_works_when_result_exists_and_is_sold
    assert_raises(Errors::ResultNotFound) do
      Invoice.create_from_result('foo')
    end

    assert_raises(Errors::ResultNotSold) do
      Invoice.create_from_result(@not_sold_result.id)
    end
  end

  def test_a_persisted_invoice_has_items
    assert_equal(1, @payable_invoice.items.count)
  end

  def test_mark_as_paid_at
    time = Time.parse('2010-07-06 10:30 +0000').in_time_zone
    @payable_invoice.mark_as_paid_at(time)

    assert(@payable_invoice.paid?)
    assert(@payable_invoice.result.payment_received?)
    assert_equal(time.to_date + 14, @payable_invoice.result.registration_due_date)
    assert_equal(time, @payable_invoice.paid_at)
  end

  def test_mark_as_paid_at_after_billing_profile_changed
    time = Time.parse('2010-07-06 10:30 +0000').in_time_zone
    billing_profile = @payable_invoice.billing_profile

    assert_equal @payable_invoice.total.to_f, 10.0

    billing_profile.update(vat_code: nil, alpha_two_country_code: 'EE') && @payable_invoice.reload && billing_profile.reload

    @payable_invoice.mark_as_paid_at(time)
    @payable_invoice.reload
    assert_equal(12.2, @payable_invoice.total.to_f)
    assert(@payable_invoice.paid?)
  end

  def test_mark_as_paid_after_estonian_vat_rate_setting_changed
    time = Time.parse('2010-07-06 10:30 +0000').in_time_zone
    billing_profile = @payable_invoice.billing_profile

    assert_equal @payable_invoice.total.to_f, 10.0

    billing_profile.update(vat_code: nil, alpha_two_country_code: 'EE') && @payable_invoice.reload && billing_profile.reload
    Setting.find_by(code: :estonian_vat_rate).update(value: 0.24)

    @payable_invoice.mark_as_paid_at(time)
    @payable_invoice.reload
    assert_equal(12.2, @payable_invoice.total.to_f)
    assert(@payable_invoice.paid?)
  end

  def test_mark_as_paid_at_with_payment_order
    time = Time.parse('2010-07-06 10:30 +0000')
    payment_order = payment_orders(:paid)
    @payable_invoice.mark_as_paid_at_with_payment_order(time, payment_order)

    assert(@payable_invoice.paid?)
    assert(@payable_invoice.result.payment_received?)
    assert_equal(time.to_date + 14, @payable_invoice.result.registration_due_date)
    assert_equal(time, @payable_invoice.paid_at)
    assert_equal(payment_order, @payable_invoice.paid_with_payment_order)
  end

  def test_does_not_mark_as_paid_at_with_payment_order_not_fully_paid
    time = Time.parse('2010-07-06 10:30 +0000')
    payment_order = payment_orders(:paid)
    initial_amount = @payable_invoice.total.to_f - 1
    payment_order.response = { initial_amount: initial_amount }
    @payable_invoice.mark_as_paid_at_with_payment_order(time, payment_order)

    refute(@payable_invoice.paid?)
    refute(@payable_invoice.result.payment_received?)
    refute_equal(time.to_date + 14, @payable_invoice.result.registration_due_date)
    refute_equal(time, @payable_invoice.paid_at)
    assert_equal(payment_order, @payable_invoice.paid_with_payment_order)
    assert_equal(initial_amount, @payable_invoice.paid_amount)
  end

  def test_mark_as_paid_populates_vat_rate_and_paid_amount
    time = Time.parse('2010-07-06 10:30 +0000').in_time_zone
    @payable_invoice.mark_as_paid_at(time)
    @payable_invoice.reload

    assert(@payable_invoice.paid?)
    assert_equal(BigDecimal('0.0'), @payable_invoice.vat_rate)
    assert_equal(BigDecimal('10.0'), @payable_invoice.paid_amount)
  end

  def test_invoice_items
    item = InvoiceItem.new(cents: 1200, name: :test_item)
    @payable_invoice.items = [item]

    assert_equal([item], @payable_invoice.items)
  end

  def test_invoice_title
    expected_number = @payable_invoice.number
    assert_equal("Invoice no. #{expected_number}", @payable_invoice.title)

    new_invoice = Invoice.new
    assert_not(new_invoice.title)
  end

  def test_payment_reminder_scope_accepts_an_argument
    travel_to @payable_invoice.due_date

    assert_equal([@payable_invoice, @orphaned_invoice].to_set,
                 Invoice.pending_payment_reminder(0).to_set)
  end

  def test_linkpay_url
    total = invoices_total([@payable_invoice]).to_s
    linkpay_token = PaymentOrders::EveryPay::LINKPAY_TOKEN
    url = @payable_invoice.linkpay_url

    assert(url.include? total)
    assert(url.include? linkpay_token)
    assert(url.include? @payable_invoice.number.to_s)
  end

  def test_linkpay_url_nil_if_paid
    time = Time.parse('2010-07-06 10:30 +0000').in_time_zone
    @payable_invoice.mark_as_paid_at(time)

    assert_nil @payable_invoice.linkpay_url
  end

  def test_if_auction_has_deposit_it_should_be_destracted_from_total
    assert_equal @payable_invoice.total.to_f, 10.0
    result = @payable_invoice.result
    result.update(auction: @english) && @payable_invoice.reload

    @english.update!(requirement_deposit_in_cents: 500, enable_deposit: true)
    @english.reload && @payable_invoice.reload

    assert @english.enable_deposit?
    assert_equal @payable_invoice.total.to_f, 5.0
  end

  def test_invoice_should_be_recalculated_if_billing_profile_updated
    assert_equal @payable_invoice.total.to_f, 10.0
    
    billing_profile = @payable_invoice.billing_profile
    billing_profile.update(vat_code: nil, alpha_two_country_code: 'LV') && @payable_invoice.reload && billing_profile.reload

    assert_equal Countries.vat_rate_from_alpha2_code(billing_profile.alpha_two_country_code), 0.21
    assert_equal @payable_invoice.total.to_f, 12.1

    billing_profile = @payable_invoice.billing_profile

    billing_profile.vat_code = '123456'
    billing_profile.alpha_two_country_code = 'LV'
    billing_profile.save(validate: false) && @payable_invoice.reload && billing_profile.reload

    assert_equal @payable_invoice.total.to_f, 10.0
  end

  def test_invoice_should_be_recalculated_if_billing_profile_changed
    assert_equal @payable_invoice.total.to_f, 10.0
    billing_profile = @payable_invoice.billing_profile
    assert billing_profile.vat_code.present?

    private_person = billing_profiles(:private_person)
    assert_not private_person.vat_code.present?
    private_person.update(alpha_two_country_code: 'LV') && private_person.reload

    @payable_invoice.billing_profile = private_person
    @payable_invoice.save(validate: false) && @payable_invoice.reload

    assert_equal Countries.vat_rate_from_alpha2_code(private_person.alpha_two_country_code), 0.21
    assert_equal @payable_invoice.total.to_f, 12.1
  end

  def test_if_price_is_nil_total_should_be_0
    invoice = prefill_invoice
    invoice.cents = nil
    invoice.vat_rate = nil
    assert_equal 0, invoice.total.to_f
  end

  def test_total_should_change_if_vat_rate_is_changed
    invoice = prefill_invoice
    invoice.cents = 1000
    invoice.vat_rate = 0.22

    assert_equal 12.2, invoice.total.to_f

    invoice.vat_rate = 0.24

    assert_equal 12.4, invoice.total.to_f
  end

  def test_total_should_be_recalculated_if_vat_rate_is_nil
    invoice = prefill_invoice
    invoice.vat_rate = nil
    invoice.country_code = 'LV'
    assert_equal 12.1, invoice.total.to_f
  end

  def invoices_total(invoices)
    invoices.map(&:total)
            .reduce(:+)
            &.format(symbol: nil, thousands_separator: false, decimal_mark: '.')
  end

  def prefill_invoice
    invoice = Invoice.new
    invoice.result = @result
    invoice.billing_profile = @company_billing_profile
    invoice.user = @user
    invoice.issue_date = Time.zone.today
    invoice.due_date = Time.zone.today + Setting.find_by(code: 'payment_term').retrieve
    invoice.cents = 1000

    invoice
  end
end
