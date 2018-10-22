require 'application_system_test_case'

class OffersTest < ApplicationSystemTestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @valid_auction = auctions(:id_test)
    travel_to Time.parse('2010-07-05 10:30 +0000')
  end

  def teardown
    super

    travel_back
  end

  def test_can_submit_an_offer_for_pending_auction
    visit auction_path(@valid_auction)

    assert(page.has_link?('Submit offer'))
  end

  def test_cannot_submit_an_offer_for_old_auction
    visit auction_path(@expired_auction)

    refute(page.has_link?('Submit offer'))
  end
end
