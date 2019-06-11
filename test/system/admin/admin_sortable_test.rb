require 'application_system_test_case'

class AdminSortableTest < ApplicationSystemTestCase
  def setup
    @administrator = users(:administrator)

    sign_in(@administrator)
  end

  def test_auctions_are_sortable
    visit admin_auctions_path

    assert(page.has_link?('sort_by_domain_name_desc'))
    assert("auctions are sortable" == :foo)
  end

  def test_users_are_sortable
    visit admin_users_path

    assert(page.has_link?('sort_by_email_desc'))
    assert("users are sortable" == :foo)
  end

  def test_results_are_sortable
    visit admin_results_path

    assert(page.has_link?('sort_by_domain_name_desc'))
    assert("results are sortable" == :foo)
  end

  def test_invoices_are_sortable
    visit admin_invoices_path

    assert(page.has_link?('sort_by_domain_name_desc'))
    assert("invoices are sortable" == :foo)
  end
end
