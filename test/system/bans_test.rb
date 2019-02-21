require 'application_system_test_case'

class BansTest < ApplicationSystemTestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @valid_auction_with_no_offers = auctions(:valid_without_offers)
    @administrator = users(:administrator)
    @participant = users(:participant)
    @other_participant = users(:second_place_participant)
    @ban = Ban.create_automatic(user: @participant,
                                domain_name: @valid_auction_with_no_offers.domain_name)

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
      assert(page.has_link?('Delete', href: admin_ban_path(@ban)))
    end

    accept_confirm do
      click_link_or_button('Delete')
    end

    assert(page.has_css?('div.notice', text: 'Deleted successfully.'))
  end

  def test_administrator_can_create_bans
    sign_in(@administrator)
    visit admin_user_path(@other_participant)

    fill_in('ban[valid_until]', with: "2200/01/01")

    assert_changes -> { Ban.count } do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.notice', text: 'Created successfully.'))
  end
end
