# encoding: UTF-8
require 'application_system_test_case'

class AdminInvoicesTest < ApplicationSystemTestCase
  def setup
    super

    @administrator = users(:administrator)
    @invoice = invoices(:orphaned)

    travel_to Time.parse('2010-07-05 10:30 +0000')
    sign_in(@administrator)
  end

  def teardown
    super

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
end
