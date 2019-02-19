require 'application_system_test_case'

class BansTest < ApplicationSystemTestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @valid_auction_with_no_offers = auctions(:valid_without_offers)
    @administrator = users(:administrator)
    @participant = users(:participant)

    travel_to Time.parse('2010-07-05 10:31 +0000')
  end

  def teardown
    super

    travel_back
  end

  def test_banned_user_cannot_create_offers
    sign_in(@participant)
    visit auction_path(@valid_auction_with_no_offers.uuid)

    assert(page.has_link?('Submit offer'))
    click_link('Submit offer')
    assert(page.has_text?('You are banned from participating in this auction.'))
  end

  def test_administrator_can_review_bans
    sign_in(@administrator)

    visit admin_bans_path

    within('tbody#bans-table-body') do
      assert_text('Permanently')

      assert(page.has_link?('Remove ban', href: admin_bans_path(@ban)))
    end
  end
end
