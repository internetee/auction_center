require 'application_system_test_case'

class BillingOffersTest < ApplicationSystemTestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @valid_auction = auctions(:valid_with_offers)
    @valid_auction_with_no_offers = auctions(:valid_without_offers)
    @user = users(:participant)
    @offer = offers(:minimum_offer)
    @expired_offer = offers(:expired_offer)
    @user_without_billing_profile = users(:second_place_participant)

    travel_to Time.parse('2010-07-05 10:31 +0000').in_time_zone
  end

  def teardown
    super
  end

  def test_user_has_default_billing_profile_created_for_them
    sign_in(@user_without_billing_profile)
    visit auction_path(@valid_auction_with_no_offers.uuid)

    assert(page.has_link?('Bid!'))
    click_link('Bid!')
    fill_in('offer[price]', with: '5.12')

    click_link_or_button('Submit')
    # assert(page.has_css?('div#flash', text: 'Offer submitted successfully.'))
  end

  def test_user_needs_to_select_a_billing_profile_when_creating_offer
    sign_in(@user)
    visit auction_path(@valid_auction_with_no_offers.uuid)

    assert(page.has_link?('Bid!'))
    click_link('Bid!')

    fill_in('offer[price]', with: '5.12')
    # select_from_dropdown('ACME Inc.', from: 'offer[billing_profile_id]')
    select 'ACME Inc.', from: 'offer[billing_profile_id]'

    click_link_or_button('Submit')

    # assert(page.has_css?('div#flash', text: 'Offer submitted successfully.'))
  end
end
