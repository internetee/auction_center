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

    click_link(id: 'admin_auction_decorators.domain_name_desc_button')
    assert_appears_before('with-offers.test', 'expired.test')
  end

  def test_newer_auctions_are_shown_on_top
    visit admin_auctions_path

    assert_appears_before('with-offers.test', 'with-invoice.test')
  end

  def test_billing_profiles_are_orderable
    visit admin_billing_profiles_path

    click_link(id: 'billing_profiles.name_asc_button')
    assert_appears_before('ACME Inc', 'Orphan Profile')
  end

  def test_newer_billing_profiles_are_shown_on_top
    visit admin_billing_profiles_path

    assert_appears_before('Joe John Participant', 'ACME Inc.')
  end

  def test_users_are_orderable
    visit admin_users_path

    click_link(id: 'users.email_asc_button')
    assert_appears_before('second_place@auction.test', 'user@auction.test')
  end

  def test_results_are_orderable
    visit admin_results_path

    click_link(id: 'auctions.domain_name_desc_button')
    assert_appears_before('with-invoice.test', 'expired.test')
  end

  def test_newer_results_are_shown_on_top
    visit admin_results_path

    assert_appears_before('expired.test', 'with-invoice.test')
  end

  def test_invoices_are_orderable
    visit admin_invoices_path

    click_link(id: 'invoices.billing_profile_id_desc_button')
    assert_appears_before('Orphan Profile', 'ACME Inc.')
  end

  def test_newer_invoices_are_shown_on_top
    visit admin_invoices_path

    assert_appears_before('ACME Inc.', 'Orphan Profile')
  end

  def test_order_links_are_with_single_parameter
    visit admin_auctions_path

    sorting_href = '/admin/auctions?order%5Badmin_auction_decorators.highest_offer_cents%5D=desc'

    click_link(id: 'admin_auction_decorators.domain_name_desc_button')
    assert(page.has_link?(href: sorting_href))
  end

  private

  def assert_appears_before(earlier_element, later_element)
    assert(page.text.index(earlier_element) < page.text.index(later_element))
  end
end
