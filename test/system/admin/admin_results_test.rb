# encoding: UTF-8
require 'application_system_test_case'

class AdminResultsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  def setup
    super

    @administrator = users(:administrator)
    sign_in(@administrator)
  end

  def teardown
    super
  end

  def test_administrator_can_see_the_list_of_auctions_pending_result
    visit(admin_results_path)

    assert(page.has_text?("These auctions have finished, but don't have a result yet:"))
    assert(page.has_table?('auctions-needing-results-table'))

    within('tbody#auctions-needing-results-table') do
      assert_text('with-offers.test')
      assert_text('no-offers.test')
    end
  end

  def test_administrator_can_schedule_a_job_to_create_auction_result
    visit(admin_results_path)
    assert(page.has_button?('Create results'))

    assert_enqueued_with(job: ResultCreationJob) do
      click_button('Create results')
      assert(page.has_text?('Job enqueued. Check in a few minutes for results.'))
    end
  end

  def test_administrator_can_see_all_created_results
    visit(admin_results_path)

    assert(page.has_table?('results-table'))

    within('tbody#results-table-body') do
      assert_text('expired.test')
      assert_text('Joe John Participant')
      assert_text('10.00 €')
    end
  end
end
