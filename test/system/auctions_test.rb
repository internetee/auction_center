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

  def test_auctions_index_contains_a_list
    visit('/')

    assert(page.has_table?('auctions-table'))
    assert(page.has_link?('with-offers.test', href: auction_path(@auction.uuid)))
    assert(page.has_link?('no-offers.test', href: auction_path(@other_auction.uuid)))
  end

  def test_search_by_domain_name_finds_all_auctions_with_common_beggining
    travel_back

    visit('/')
    fill_in('domain_name', with: "w")
    find(:css, "i.arrow.right.icon").click

    assert(page.has_link?('with-invoice.test'))
    assert(page.has_link?('with-offers.test'))
    assert(page.has_text?('Search results are limited to first 20 hits.'))
  end

  def test_search_does_not_find_auctions_by_top_level_domain
    travel_back

    visit('/')
    fill_in('domain_name', with: ".test")
    find(:css, "i.arrow.right.icon").click

    refute(page.has_link?('with-invoice.test'))
    refute(page.has_link?('with-offers.test'))
  end

  def test_auctions_index_contains_a_link_to_terms_and_conditions
    visit('/')

    assert(
      page.has_link?('auctioning process',
                     href: 'https://www.internet.ee/help-and-info/faq#III__ee_domain_auctions')
    )

    assert(page.has_link?('terms and conditions', href: Setting.terms_and_conditions_link))
  end

  def test_auctions_index_does_not_contain_auctions_that_are_finished
    visit('/')

    refute(page.has_link?('expired.test'))
  end

  def test_show_page_for_finished_auctions_still_exists
    visit(auction_path(@expired_auction.uuid))
    assert(page.has_content?('h3', 'This auction has finished'))
    assert(page.has_content?('dd', 'expired.test'))
  end

  def test_show_page_contains_the_details_of_the_auction
    visit(auction_path(@auction.uuid))

    assert(page.has_content?('dd', 'with-offers.test'))
    assert(page.has_content?('dd', '2010-07-06 10:30'))
  end
end
