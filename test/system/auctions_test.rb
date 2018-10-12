require 'application_system_test_case'

class AuctionsTest < ApplicationSystemTestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
    @auction = auctions(:id_test)
  end

  def teardown
    super

    travel_back
  end

  def test_auction_index_contains_a_list
    visit(auctions_path)

    assert(page.has_table?('auctions-table'))
    assert(page.has_link?('id.test', href: auction_path(@auction.id)))
  end

  def test_show_page_contains_the_details_of_the_auction
    visit(auction_path(@auction))

    assert(page.has_content?('dd', 'id.test'))
    assert(page.has_content?('dd', '2010-07-06 10:30'))
  end
end
