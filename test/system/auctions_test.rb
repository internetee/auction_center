require 'application_system_test_case'

class AuctionsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
    @auction = auctions(:valid_with_offers)
    @other_auction = auctions(:valid_without_offers)
    @expired_auction = auctions(:expired)
  end

  def teardown
    super

    travel_back
  end

  def test_result_creation_job_is_scheduled_automatically_if_there_ended_are_auctions
    travel_back

    assert_enqueued_with(job: ResultCreationJob) do
      visit('/')
    end
  end

  def test_result_creation_job_is_not_scheduled_when_there_are_no_ended_auctions
    travel_back

    assert_no_enqueued_jobs(only: ResultCreationJob) do
      visit('/')
    end
  end

  def test_auctions_index_contains_a_list
    visit('/')

    assert(page.has_table?('auctions-table'))
    assert(page.has_link?('with-offers.test', href: auction_path(@auction.id)))
    assert(page.has_link?('no-offers.test', href: auction_path(@other_auction.id)))
  end

  def test_auctions_index_does_not_contain_auctions_that_are_finished
    visit('/')

    refute(page.has_link?('expired.test'))
  end

  def test_show_page_for_finished_auctions_still_exists
    visit(auction_path(@expired_auction))
    assert(page.has_content?('h3', 'This auction has finished'))
    assert(page.has_content?('dd', 'expired.test'))
  end

  def test_show_page_contains_the_details_of_the_auction
    visit(auction_path(@auction))

    assert(page.has_content?('dd', 'with-offers.test'))
    assert(page.has_content?('dd', '2010-07-06 10:30'))
  end
end
