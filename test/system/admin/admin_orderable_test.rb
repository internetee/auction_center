require 'application_system_test_case'

class AdminOrderableTest < ApplicationSystemTestCase
  def setup
    super

    @original_wait_time = Capybara.default_max_wait_time
    Capybara.default_max_wait_time = 10

    @administrator = users(:administrator)
    sign_in(@administrator)
  end

  def teardown
    super

    Capybara.default_max_wait_time = @original_wait_time
  end

  def test_auctions_are_orderable
    visit admin_auctions_path

    click_link(id: 'auctions.domain_name_desc_button')
    assert_appears_before('with-offers.test', 'expired.test')
  end

  def test_users_are_orderable
    visit admin_users_path

    click_link(id: 'users.email_desc_button')
    assert_appears_before('with-offers.test', 'expired.test')
  end

  def test_results_are_orderable
    visit admin_results_path

    assert(page.has_link?('auctions.domain_name_asc_button'))
  end

  def test_invoices_are_orderable
    visit admin_invoices_path

    assert(page.has_link?('auctions.domain_name_asc_button'))
  end

  def assert_appears_before(earlier_element, later_element)
    assert(page.text.index(earlier_element) < page.text.index(later_element))
  end
end
