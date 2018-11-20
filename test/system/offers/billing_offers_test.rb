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

    travel_to Time.parse('2010-07-05 10:31 +0000')
  end

  def teardown
    super
  end

  def test_user_needs_to_select_a_billing_profile_when_creating_offer
    sign_in(@user)
    visit auction_path(@valid_auction_with_no_offers)

    assert(page.has_link?('Submit offer'))
    click_link('Submit offer')

    fill_in('offer[price]', with: '5.12')
    select('ACME Inc.', from: 'offer[billing_profile_id]')
    click_link_or_button('Submit')
  end
end
