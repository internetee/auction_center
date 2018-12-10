# encoding: UTF-8
require 'application_system_test_case'

class InvoicesTest < ApplicationSystemTestCase
  def setup
    super

    @user = users(:participant)
    @invoice = invoices(:payable)

    travel_to Time.parse('2010-07-05 10:30 +0000')

    sign_in(@user)
  end

  def teardown
    super

    travel_back
  end

  def test_user_can_update_billing_profile_on_issued_invoice
    visit invoice_path(@invoice)

    assert(page.has_link?('Change billing profile', href: edit_invoice_path(@invoice)))

    click_link_or_button('Change billing profile')
    select('Joe John Participant', from: 'invoice[billing_profile_id]')
    click_link_or_button('Submit')

    assert_text('Updated successfully')
    assert_text('Joe John Participant')
  end

  def test_invoice_contains_items_and_prices_without_vat
    visit invoice_path(@invoice)

    assert_text("Domain transfer code for with-invoice.test")
    assert_text('VAT exclusive 10.00 €')
    assert_text('VAT rate 0%')
    assert_text('VAT 0.00 €')
    assert_text('Total 10.00 €')
  end

  def test_invoice_list_contains_issued_invoices
    visit invoices_path

    within('tbody.invoices-table-body') do
      assert_text("Domain transfer code for with-invoice.test")
      assert_text("10.00 €")
    end
  end
end
