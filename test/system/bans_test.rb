require 'application_system_test_case'

class BansTest < ApplicationSystemTestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:31 +0000')

    @expired_auction = auctions(:expired)
    @valid_auction_with_no_offers = auctions(:valid_without_offers)
    @valid_auction_with_offers = auctions(:valid_with_offers)
    @administrator = users(:administrator)
    @participant = users(:participant)
    @other_participant = users(:second_place_participant)
    @ban = Ban.create_automatic(user: @participant,
                                domain_name: @valid_auction_with_no_offers.domain_name)
  end

  def teardown
    super

    travel_back
  end

  def test_banned_user_cannot_create_offers
    sign_in(@participant)

    visit auction_path(@valid_auction_with_no_offers.uuid)
    click_link('Submit offer')
    fill_in('offer[price]', with: '5.12')

    click_link_or_button('Submit')

    assert(page.has_css?('div.alert', text: 'You are not authorized to access this page'))
  end

  def test_banned_user_can_submit_offers_for_other_auctions
    @valid_auction_with_offers.offers.destroy_all

    sign_in(@participant)
    visit auction_path(@valid_auction_with_offers.uuid)
    click_link('Submit offer')
    fill_in('offer[price]', with: '5.12')
    click_link_or_button('Submit')

    assert(page.has_text?('Offer submitted successfully.'))
  end

  def test_banned_user_can_view_their_information
    sign_in(@participant)

    visit user_path(@participant.uuid)
    refute(page.has_css?('div.alert', text: 'You are not authorized to access this page'))

    click_link_or_button('Edit')
    assert(page.has_css?('div.alert', text: 'You are not authorized to access this page'))
  end

  def test_banned_user_cannot_delete_their_account
    sign_in(@participant)

    visit user_path(@participant.uuid)

    accept_confirm do
      click_link_or_button('Delete')
    end

    assert(page.has_css?('div.alert', text: 'You are not authorized to access this page'))
  end

  def test_banned_user_can_see_a_red_banner
    sign_in(@participant)

    text = <<~TEXT.squish
    You are banned until 2010-10-05, you are not allowed to change your user data or participate in
    auctions for no-offers.test domain.
    TEXT

    visit auctions_path
    assert(page.has_css?('div.ban', text: text))
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

    fill_in('ban[valid_until]', with: "01/01/2222")
    assert_changes -> { Ban.count } do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.notice', text: 'Created successfully.'))
  end

 def test_administrator_cannot_create_bans_that_are_valid_in_the_past
    sign_in(@administrator)
    visit admin_user_path(@other_participant)

    fill_in('ban[valid_until]', with: "01/01/1999")
    assert_no_changes -> { Ban.count } do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.notice', text: 'Something went wrong.'))
  end
end
