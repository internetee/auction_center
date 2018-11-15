# encoding: UTF-8
require 'application_system_test_case'

class OffersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  def setup
    super

    @expired_auction = auctions(:expired)
    @valid_auction = auctions(:valid_with_offers)
    @valid_auction_with_no_offers = auctions(:valid_without_offers)
    @user = users(:participant)
    @offer = offers(:minimum_offer)
    @expired_offer = offers(:expired_offer)

    travel_to Time.parse('2010-07-05 10:31 +0000')
  end

  def teardown
    super

    travel_back
  end

  def test_result_creation_job_is_scheduled_automatically
    sign_in(@user)
    assert_enqueued_with(job: ResultCreationJob) do
      visit(offers_path)
    end
  end

  def test_root_has_a_link_to_offers_page
    sign_in(@user)
    visit root_path

    assert(page.has_link?('My offers', href: offers_path))
    click_link('My offers')

    within('tbody#offers-table-body') do
      assert_text('with-offers.test')
      assert_text('5.00 €')

      assert(page.has_link?('with-offers.test', href: offer_path(@offer)))
    end
  end

  def test_needs_to_be_signed_in_to_submit_an_offer
    visit auction_path(@valid_auction)
    click_link('Submit offer')

    assert_text('You need to sign in or sign up before continuing')
  end

  def test_participant_can_submit_an_offer_for_pending_auction
    sign_in(@user)
    visit auction_path(@valid_auction_with_no_offers)

    assert(page.has_link?('Submit offer'))
    click_link('Submit offer')

    fill_in('offer[price]', with: '5.12')
    click_link_or_button('Submit')

    assert(page.has_text?('Created successfully'))
  end

  def test_participant_cannot_submit_an_offer_with_3_or_more_decimal_places
    sign_in(@user)
    visit auction_path(@valid_auction_with_no_offers)

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
    visit offer_path(@offer)

    click_link_or_button('Edit')

    fill_in('offer[price]', with: '5')
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

  def test_participant_cannot_delete_an_offer_for_old_auction
    sign_in(@user)
    visit offer_path(@expired_offer)

    refute(page.has_link?('Delete'))
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
