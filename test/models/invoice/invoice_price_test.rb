require 'test_helper'

class InvoicePriceTest < ActiveSupport::TestCase
  def setup
    super

    @payable_invoice = invoices(:payable)
    @orphaned_invoice = invoices(:orphaned)
  end

  def test_vat_returns_payable_vat_for_UK_profile
    assert_equal(Money.new('0', 'EUR'), @payable_invoice.vat)
    assert_equal(Money.new('0', 'EUR'), @orphaned_invoice.vat)
  end

  def test_total_returns_price_plus_vat_for_UK_profile
    assert_equal(Money.new('1000', 'EUR'), @payable_invoice.total)
    assert_equal(Money.new('1000', 'EUR'), @orphaned_invoice.total)
  end
end
