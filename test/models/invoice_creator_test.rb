require 'test_helper'

class InvoiceCreatorTest < ActiveSupport::TestCase
  def setup
    super

    @result = results(:expired_participant)
  end

  def test_an_invoice_is_prefilled_with_data_from_winning_offer
    invoice_creator = InvoiceCreator.new(@result.id)

    invoice = invoice_creator.call

    assert(invoice.is_a?(Invoice))
    assert_equal(@result, invoice.result)
    assert_equal(@result.user, invoice.user)
  end
end
