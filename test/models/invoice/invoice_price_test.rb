require 'test_helper'

class InvoicePriceTest < ActiveSupport::TestCase
  def setup
    super

    @invoice = invoices(:orphaned)
  end

  def test_vat_is_skipped_for_customers_with_vat_number
    skip
  end

  def test_vat_is_calculated_for_customers_without_vat_number
    skip
  end
end
