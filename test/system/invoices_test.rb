require 'application_system_test_case'

class InvoicesTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  def setup
    super

    @user = users(:participant)
    @invoice = invoices(:payable)

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone

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

    @invoice.reload

    page.find :css, '#flash', wait: 10
    assert_text('Updated successfully')
    page.html.include? 'Joe John Participant'

    assert_equal("#{@user.id} - Joe John Participant", @invoice.updated_by)
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
    setting.update!(value: 'foo bar baz')

    visit invoice_path(@invoice.uuid)
    assert_text('foo bar baz')
  end

  def test_invoice_view_contains_a_download_link
    visit invoice_path(@invoice.uuid)
    assert_link 'Download', href: download_invoice_path(@invoice.uuid)
  end

  def test_invoice_contains_items_and_prices_without_vat
    visit invoice_path(@invoice.uuid)

    assert_text('Domain transfer code for with-invoice.test')
    assert_text('VAT exclusive 10.00 €')
    assert_text('VAT rate 0%')
    assert_text('VAT 0.00 €')
    assert_text('Total 10.00 €')
  end

  def test_invoice_list_contains_issued_invoices
    visit invoices_path

    within('tbody.invoices-table-body.issued') do
      assert_text('Domain transfer code for with-invoice.test')
      assert_text('10.00 €')
    end
  end

  def test_invoice_list_contains_cancelled_invoices
    @invoice.update(status: Invoice.statuses[:cancelled])
    @invoice.reload
    visit invoices_path

    within('tbody.invoices-table-body.cancelled') do
      assert_text('Domain transfer code for with-invoice.test')
      assert_text('10.00')
    end
  end

  def test_a_user_can_pay_invoice_via_every_pay
    visit invoice_path(@invoice.uuid)

    assert(page.has_link?(href: @invoice.linkpay_url))
    page.find_link(href: @invoice.linkpay_url)
  end

  def test_a_user_can_pay_for_cancelled_invoice_with_valid_ban
    @invoice.update!(status: Invoice.statuses[:cancelled])
    AutomaticBan.new(invoice: @invoice, user: @user, domain_name: 'some-domain.test').create

    visit invoice_path(@invoice.uuid)
    assert(assert(page.has_link?(href: @invoice.linkpay_url)))
  end

  def test_a_user_cannot_pay_for_cancelled_invoice_with_expired_ban
    @invoice.update!(status: Invoice.statuses[:cancelled])
    AutomaticBan.new(invoice: @invoice, user: @user, domain_name: 'some-domain.test').create
    Ban.last.update(valid_from: Time.zone.now - 10.days,
                    valid_until: Time.zone.now - 1.day)

    visit invoice_path(@invoice.uuid)
    assert_not(page.has_css?('form#every_pay'))
  end

  def test_a_user_cannot_pay_for_paid_invoice
    @invoice.update!(status: Invoice.statuses[:paid], paid_at: Time.zone.now)
    visit invoice_path(@invoice.uuid)
    assert_not(page.has_css?('form#every_pay'))
  end
end
