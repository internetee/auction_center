require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def setup
    super

    @result = results(:expired_participant)
    @user = users(:participant)
    @orphan_billing_profile = billing_profiles(:orphan)
    @company_billing_profile = billing_profiles(:company)
  end

  def test_price_is_a_money_object
    invoice = Invoice.new(cents: 1000)

    assert_equal(Money.new(1000, Setting.auction_currency), invoice.price)

    invoice.cents = nil
    assert_equal(Money.new(0, Setting.auction_currency), invoice.price)
  end

  def test_required_fields
    invoice = Invoice.new
    refute(invoice.valid?)

    assert_equal(['must exist'], invoice.errors[:result])
    assert_equal(['must exist'], invoice.errors[:billing_profile])

    invoice.result = @result
    invoice.billing_profile = @orphan_billing_profile

    assert(invoice.valid?)
  end

  def test_user_must_be_the_same_as_the_one_on_billing_or_nil
    invoice = Invoice.new
    invoice.result = @result
    invoice.billing_profile = @orphan_billing_profile
    invoice.user = @user

    refute(invoice.valid?)
    assert_equal(['must belong to the same user as invoice'], invoice.errors[:billing_profile])

    invoice.user = nil
    assert(invoice.valid?)
  end
end
