# encoding: UTF-8
require 'application_system_test_case'

class OffersTest < ApplicationSystemTestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @valid_auction = auctions(:valid_with_offers)
    @valid_auction_with_no_offers = auctions(:valid_without_offers)
    @user = users(:participant)
    @offer = offers(:high_offer)
    @expired_offer = offers(:expired_offer)

    travel_to Time.parse('2010-07-05 10:31 +0000')
  end

  def teardown
    super

    travel_back
  end

  def test_root_has_a_link_to_offers_page
    sign_in(@user)
    visit root_path

    assert(page.has_link?('My offers', href: offers_path))
  end

  def test_user_cannot_create_offers_in_the_name_of_other_user
    sign_in(@user)

    other_user = users(:second_place_participant)

    visit auction_path(@valid_auction_with_no_offers.uuid)

    assert(page.has_link?('Submit offer'))
    click_link('Submit offer')

    fill_in('offer[price]', with: '5.12')
    page.evaluate_script("document.getElementById('offer_user_id').value = '#{other_user.id}'")

    click_link_or_button('Submit')
    assert(page.has_css?('div.alert', text: 'You are not authorized to access this page'))
  end

  def test_offer_submission_has_a_disclaimer_text
    sign_in(@user)
    visit auction_path(@valid_auction_with_no_offers.uuid)

    assert(page.has_link?('Submit offer'))
    click_link('Submit offer')

    expected_minimum_offer_text = 'Minimum offer is 5.00. The offer does not include VAT'
    assert(page.has_text?(expected_minimum_offer_text))

    expected_text =
      'NB: This is blind auction and the domain name might have others interested in it as well.' \
      ' No information about other bids does not mean there are not any.' \
      ' Make a bid according to the value of the domain name to you.'
    assert_text(expected_text)
  end

  def test_offers_table_rows_have_links_to_each_offer
    sign_in(@user)
    visit offers_path

    within('tbody#offers-table-body') do
      assert_text('with-offers.test')
      assert_text('50.00 €')
      assert_text('60.00 €')

      assert(page.has_link?('with-offers.test', href: offer_path(@offer.uuid)))
    end
  end

  def test_needs_to_be_signed_in_to_submit_an_offer
    visit auction_path(@valid_auction.uuid)
    click_link('Submit offer')

    assert_text('You need to sign in or sign up before continuing')
  end

  def test_gets_redirected_to_an_offer_if_one_exists
    sign_in(@user)
    visit new_auction_offer_path(@valid_auction.uuid)

    assert_text('You already have an offer for this auction.')
    assert_equal(edit_offer_path(@offer.uuid), current_path)
  end

  def test_participant_can_submit_an_offer_for_pending_auction
    sign_in(@user)
    visit auction_path(@valid_auction_with_no_offers.uuid)

    assert(page.has_link?('Submit offer'))
    click_link('Submit offer')

    fill_in('offer[price]', with: '5.12')
    click_link_or_button('Submit')

    assert(page.has_text?('Offer submitted successfully.'))
  end

  def test_participant_cannot_submit_an_offer_with_3_or_more_decimal_places
    sign_in(@user)
    visit auction_path(@valid_auction_with_no_offers.uuid)

    assert(page.has_link?('Submit offer'))
    click_link('Submit offer')

    fill_in('offer[price]', with: '5.121')

    # Check in-browser validation
    validation_message = find("#offer_price").native.attribute("validationMessage")
    assert_equal("Please enter a valid value. The two nearest valid values are 5.12 and 5.13.",
                 validation_message)

    assert_no_changes('Offer.count') do
      click_link_or_button('Submit')
    end
  end

  def test_participant_can_update_an_offer
    sign_in(@user)
    visit offer_path(@offer.uuid)

    click_link_or_button('Edit')

    fill_in('offer[price]', with: '5')
    click_link_or_button('Submit')

    assert(page.has_text?('Updated successfully'))

    @offer.reload
    assert_equal("#{@user.id} - Joe John Participant", @offer.updated_by)
  end

  def test_participant_can_delete_an_offer
    sign_in(@user)
    visit offer_path(@offer.uuid)

    assert(page.has_link?('Delete'))

    accept_confirm do
      click_link_or_button('Delete')
    end

    assert(page.has_text?('Deleted successfully'))
  end

  def test_participant_cannot_delete_an_offer_for_old_auction
    sign_in(@user)
    visit offer_path(@expired_offer.uuid)

    refute(page.has_link?('Delete'))
  end

  def test_participant_cannot_submit_an_offer_for_old_auction
    sign_in(@user)
    visit auction_path(@expired_auction.uuid)

    refute(page.has_link?('Submit offer'))

    visit new_auction_offer_path(@expired_auction.uuid)

    fill_in('offer[price]', with: '5.00')
    click_link_or_button('Submit')

    assert(page.has_text?('Auction must be active'))
  end

  def test_participant_cannot_update_an_offer_for_an_inactive_auction
    travel_to Time.parse('2010-08-05 10:30 +0000')
    sign_in(@user)

    visit edit_offer_path(@offer.uuid)

    fill_in('offer[price]', with: '5.00')
    click_link_or_button('Submit')

    assert(page.has_text?('Auction must be active'))
  end
end
