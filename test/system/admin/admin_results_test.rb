# encoding: UTF-8
require 'application_system_test_case'

class AdminResultsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  def setup
    super

    @administrator = users(:administrator)
    @result = results(:expired_participant)
    @orphaned_result =results(:orphaned)
    @offer = offers(:expired_offer)
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

  def test_administrator_can_see_details_of_a_result
    visit(admin_results_path)
    assert(page.has_link?('expired.test', href: admin_result_path(@result)))

    click_link('expired.test')

    assert(page.has_table?('result-offers-table'))
    within('table#result-offers-table') do
      assert(page.has_link?('Versions'))
    end
  end

  def test_search_by_domain_name
    visit(admin_results_path)

    fill_in('domain_name', with: "expired")
    find(:css, "i.arrow.right.icon").click

    assert(page.has_link?('expired.test'))
    assert(page.has_text?('Search results are limited to first 20 hits.'))
  end

  def test_administrator_can_see_details_of_an_orphaned_result
    visit(admin_result_path(@orphaned_result))
    assert(page.has_table?('result-offers-table'))

    within('table#result-offers-table') do
      assert(page.has_link?('Versions'))
    end
  end

  def test_administrator_can_see_all_created_results
    visit(admin_results_path)

    assert(page.has_table?('results-table'))

    within('tbody#results-table-body') do
      assert_text('expired.test')
      assert_text('Joe John Participant')
      assert_text('no-offers.test')
    end
  end
end
