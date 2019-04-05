# encoding: UTF-8
require 'application_system_test_case'

class InvoicesTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

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
    visit invoice_path(@invoice.uuid)

    assert(page.has_link?('Change billing profile', href: edit_invoice_path(@invoice.uuid)))

    click_link_or_button('Change billing profile')
    select_from_dropdown('Joe John Participant', from: 'invoice[billing_profile_id]')
    click_link_or_button('Submit')

    assert_text('Updated successfully')
    assert_text('Joe John Participant')
  end

  def test_user_cannot_update_billing_profile_on_paid_invoice
    @invoice.mark_as_paid_at(Time.now.utc)
    @invoice.reload

    visit edit_invoice_path(@invoice.uuid)
    select_from_dropdown('Joe John Participant', from: 'invoice[billing_profile_id]')
    click_link_or_button('Submit')

    assert_text('Something went wrong.')
    assert_text('ACME Inc.')
  end

  def test_invoice_view_contains_issuer_info
    visit invoice_path(@invoice.uuid)
    assert_text('Eesti Interneti SA, VAT number EE101286464')

    setting = settings(:invoice_issuer)
    setting.update!(value: "foo bar baz")

    visit invoice_path(@invoice.uuid)
    assert_text('foo bar baz')
  end

  def test_invoice_can_be_downloaded
    visit invoice_path(@invoice.uuid)
    assert(page.has_link?('Download', href: download_invoice_path(@invoice.uuid)))

    new_window = window_opened_by { click_link_or_button('Download') }
    assert(new_window)
  end

  def test_invoice_contains_items_and_prices_without_vat
    visit invoice_path(@invoice.uuid)

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

  def test_a_user_can_pay_invoice_via_every_pay
    visit invoice_path(@invoice.uuid)

    assert(page.has_css?("form#every_pay"))

    within('form#every_pay') do
      click_link_or_button('Submit')
    end

    assert(page.has_text?('You are being redirected to the payment gateway'))
  end

  def test_a_user_cannot_pay_for_cancelled_invoice
    @invoice.update!(status: Invoice.statuses[:cancelled])
    visit invoice_path(@invoice.uuid)
    refute(page.has_css?("form#every_pay"))
  end

  def test_a_user_cannot_pay_for_paid_invoice
    @invoice.update!(status: Invoice.statuses[:paid], paid_at: Time.zone.now)
    visit invoice_path(@invoice.uuid)
    refute(page.has_css?("form#every_pay"))
  end
end
