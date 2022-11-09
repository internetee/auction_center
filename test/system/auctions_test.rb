require 'application_system_test_case'

class AuctionsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    @auction = auctions(:valid_with_offers)
    @other_auction = auctions(:valid_without_offers)
    @expired_auction = auctions(:expired)
    @orphaned_auction = auctions(:orphaned)
    @english_auction = auctions(:english)
    @english_nil_auction = auctions(:english_nil_starts)
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
    assert(page.has_link?('english_auction.test', href: auction_path(@english_auction.uuid)))
    assert(page.has_no_link?('english_nil_auction.test', href: auction_path(@english_nil_auction.uuid)))
  end

  def test_numbers_have_a_span_class_in_index_list
    visit('/')

    assert(span_element = page.find('span.number-in-domain-name'))
    assert_equal('123', span_element.text)
  end

  def test_numbers_have_a_span_class_in_show_view
    visit(auction_path(@orphaned_auction.uuid))

    assert(span_element = page.find('span.number-in-domain-name'))
    assert_equal('123', span_element.text)
  end

  def test_auctions_index_contains_a_link_to_terms_and_conditions
    visit('/')

    assert(
      page.has_link?('auctioning process',
                     href: 'https://www.internet.ee/help-and-info/faq#III__ee_domain_auctions')
    )

    assert(page.has_link?('terms and conditions', href: Setting.find_by(code: 'terms_and_conditions_link').retrieve))
  end

  def test_auctions_index_does_not_contain_auctions_that_are_finished
    visit('/')

    assert_not(page.has_link?('expired.test'))
  end

  def test_show_page_for_finished_auctions_still_exists
    visit(auction_path(@expired_auction.uuid))
    assert(page.has_content?(:visible, 'This auction has finished'))
    assert(page.has_content?(:visible, 'expired.test'))
  end

  def test_show_page_contains_the_details_of_the_auction
    visit(auction_path(@auction.uuid))

    assert(page.has_content?(:visible, 'with-offers.test'))
    assert(page.has_content?(:visible, '2010-07-06 10:30'))
  end

  def test_for_english_auction_should_be_bid_button
    visit('/')

    assert(page.has_link?('english_auction.test', href: auction_path(@english_auction.uuid)))
    assert(page.has_link?('Bid!'))
  end
end
