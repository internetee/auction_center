require 'application_system_test_case'

class AdminInvoicesTest < ApplicationSystemTestCase
  def setup
    super

    @administrator = users(:administrator)
    @invoice = invoices(:orphaned)

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    sign_in(@administrator)

    @original_wait_time = Capybara.default_max_wait_time
    Capybara.default_max_wait_time = 10
  end

  def teardown
    super

    Capybara.default_max_wait_time = @original_wait_time
    travel_back
  end

  def test_invoice_list_contains_all_invoices
    visit admin_invoices_path

    within('tbody.invoices-table-body') do
      assert_text('Orphan Profile')
      assert_text('12.00 €')
      assert_text('10.00 €')
    end

    click_link('Orphan Profile')

    assert(page.has_link?('Versions', href: admin_invoice_versions_path(@invoice)))
  end

  def test_admin_can_mark_invoice_as_paid
    note = 'Money received by wire transfer'

    visit admin_invoice_path(@invoice)

    click_link_or_button('Mark as paid')
    fill_in('invoice[notes]', with: note)

    click_link_or_button('Submit')
    assert(page.has_css?('div.notice', text: 'Invoice marked as paid.'))

    @invoice.reload

    assert(@invoice.paid?)
    assert_equal(Time.zone.now, @invoice.paid_at)
    assert_equal(note, @invoice.notes)
    assert_equal("#{@administrator.id} - John Joe Administrator", @invoice.updated_by)
  end

  def test_mark_as_paid_link_is_not_visible_if_invoice_is_overdue_or_paid
    @invoice.update(issue_date: Time.zone.today - 30,
                    due_date: Time.zone.yesterday)

    visit admin_invoice_path(@invoice)
    assert_not(page.has_link?('Mark as paid'))

    @invoice.update(status: Invoice.statuses[:paid], paid_at: Time.now.in_time_zone,
                    vat_rate: @invoice.billing_profile.vat_rate,
                    paid_amount: @invoice.total,
                    due_date: Time.zone.tomorrow)

    visit admin_invoice_path(@invoice)
    assert_not(page.has_link?('Mark as paid'))
  end

  def test_admin_can_see_which_channel_was_used_to_pay_the_invoice
    @invoice.update(status: Invoice.statuses[:paid], paid_at: Time.now,
                    vat_rate: @invoice.billing_profile.vat_rate,
                    paid_amount: @invoice.total,
                    paid_with_payment_order: payment_orders(:issued))

    visit admin_invoices_path
    assert(page.has_text?('EveryPay'))

    visit admin_invoice_path(@invoice)
    assert(page.has_text?('EveryPay'))
  end

  def test_admin_cannot_open_edit_page_if_invoice_is_already_paid
    visit admin_invoice_path(@invoice)

    @invoice.update(status: Invoice.statuses[:paid], paid_at: Time.now.in_time_zone,
                    vat_rate: @invoice.billing_profile.vat_rate,
                    paid_amount: @invoice.total)

    click_link_or_button('Mark as paid')
    assert(page.has_css?('div.notice', text: 'Invoice is already paid.'))
  end

  def test_admin_cannot_update_invoice_if_invoice_is_already_paid
    visit edit_admin_invoice_path(@invoice)

    @invoice.update(status: Invoice.statuses[:paid], paid_at: Time.now.in_time_zone,
                    vat_rate: @invoice.billing_profile.vat_rate,
                    paid_amount: @invoice.total)

    note = 'Money received by wire transfer'
    fill_in('invoice[notes]', with: note)
    click_link_or_button('Submit')

    assert(page.has_css?('div.notice', text: 'Invoice is already paid.'))

    @invoice.reload

    assert(@invoice.paid?)
    assert_not_equal(note, @invoice.notes)
    assert_not_equal("#{@administrator.id} - John Joe Administrator", @invoice.updated_by)
  end

  def test_invoice_view_contains_a_download_link
    visit admin_invoice_path(@invoice)
    assert_link 'Download', href: download_admin_invoice_path(@invoice)
  end
end
