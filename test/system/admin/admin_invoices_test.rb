# encoding: UTF-8
require 'application_system_test_case'

class AdminInvoicesTest < ApplicationSystemTestCase
  def setup
    super

    @administrator = users(:administrator)
    @invoice = invoices(:orphaned)

    travel_to Time.parse('2010-07-05 10:30 +0000')
    sign_in(@administrator)

    @original_wait_time = Capybara.default_max_wait_time
    Capybara.default_max_wait_time = 10
  end

  def teardown
    super

    Capybara.default_max_wait_time = @original_wait_time
    travel_back
  end

  def test_search_by_users_email
    visit admin_invoices_path

    fill_in('email', with: '.test')
    find(:css, "i.arrow.right.icon").click

    assert(page.has_link?('ACME Inc.'))
    assert(page.has_text?('Search results are limited to first 20 hits.'))
  end

  def test_invoice_list_contains_all_invoices
    visit admin_invoices_path

    within('tbody.invoices-table-body') do
      assert_text('Orphan Profile')
      assert_text("12.00 €")
      assert_text("10.00 €")
    end

    click_link('Orphan Profile')

    assert(page.has_link?('Versions', href: admin_invoice_versions_path(@invoice)))
  end

  def test_admin_can_mark_invoice_as_paid
    visit admin_invoice_path(@invoice)

    accept_confirm do
      click_link_or_button('Mark as paid')
    end

    assert(page.has_css?('div.notice', text: 'Invoice marked as paid.'))

    @invoice.reload

    assert(@invoice.paid?)
    assert_equal(Time.zone.now, @invoice.paid_at)
    assert_equal("#{@administrator.id} - John Joe Administrator", @invoice.updated_by)
  end

  def test_mark_as_paid_link_is_not_visible_if_invoice_is_overdue_or_paid
    @invoice.update(issue_date: Time.zone.today - 30,
                    due_date: Time.zone.yesterday)

    visit admin_invoice_path(@invoice)
    refute(page.has_link?('Mark as paid'))

    @invoice.update(status: Invoice.statuses[:paid], paid_at: Time.now,
                    vat_rate: @invoice.billing_profile.vat_rate,
                    total_amount: @invoice.total, due_date: Time.zone.tomorrow)

    visit admin_invoice_path(@invoice)
    refute(page.has_link?('Mark as paid'))
  end

  def test_admin_cannot_mark_invoice_as_paid_if_it_has_been_paid
    visit admin_invoice_path(@invoice)

    @invoice.update(status: Invoice.statuses[:paid], paid_at: Time.now,
                    vat_rate: @invoice.billing_profile.vat_rate, total_amount: @invoice.total)

    accept_confirm do
      click_link_or_button('Mark as paid')
    end

    assert(page.has_css?('div.notice', text: 'Invoice is already paid.'))
  end

  def test_invoice_can_be_downloaded
    visit admin_invoice_path(@invoice)
    assert(page.has_link?('Download', href: download_admin_invoice_path(@invoice)))

    new_window = window_opened_by { click_link_or_button('Download') }
    assert(new_window)
  end
end
