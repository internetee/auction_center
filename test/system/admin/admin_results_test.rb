require 'application_system_test_case'

class AdminResultsTest < ApplicationSystemTestCase
  def setup
    super

    @administrator = users(:administrator)
    sign_in(@administrator)
  end

  def teardown
    super
  end

  def test_administrator_can_see_all_created_auctions
    visit(admin_results_path)

    assert(page.has_table?('results-table'))
  end
end
