require 'application_system_test_case'

class OffersTest < ApplicationSystemTestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @valid_auction = auctions(:id_test)
    @user = users(:participant)
    @offer = offers(:minimum_id_test_offer)

    travel_to Time.parse('2010-07-05 10:30 +0000')
  end

  def teardown
    super

    travel_back
  end

  def test_needs_to_be_signed_in_to_submit_an_offer
    visit auction_path(@valid_auction)
    click_link('Submit offer')

    assert_text('You need to sign in or sign up before continuing')
  end

  def test_participant_can_submit_an_offer_for_pending_auction
    sign_in(@user)
    visit auction_path(@valid_auction)

    assert(page.has_link?('Submit offer'))
    click_link('Submit offer')

    fill_in('offer[price]', with: '5.00')
    click_link_or_button('Submit')

    assert(page.has_text?('Created successfully'))
  end

  def test_participant_can_update_an_offer
    sign_in(@user)
    visit offer_path(@offer)

    click_link_or_button('Edit')

    fill_in('offer[price]', with: '5.00')
    click_link_or_button('Submit')

    assert(page.has_text?('Updated successfully'))
  end

  def test_participant_can_delete_an_offer
    sign_in(@user)
    visit offer_path(@offer)

    accept_confirm do
      click_link_or_button('Delete')
    end

    assert(page.has_text?('Deleted successfully'))
  end

  def test_participant_cannot_submit_an_offer_for_old_auction
    sign_in(@user)
    visit auction_path(@expired_auction)

    refute(page.has_link?('Submit offer'))

    visit new_auction_offer_path(@expired_auction)

    fill_in('offer[price]', with: '5.00')
    click_link_or_button('Submit')

    assert(page.has_text?('Auction must be active'))
  end

  def test_participant_cannot_update_an_offer_for_an_inactive_auction
    travel_to Time.parse('2010-08-05 10:30 +0000')
    sign_in(@user)

    visit edit_offer_path(@offer)

    fill_in('offer[price]', with: '5.00')
    click_link_or_button('Submit')

    assert(page.has_text?('Auction must be active'))
  end
end
