require 'application_system_test_case'
require 'messente/omnimessage'

class PhoneConfirmationsTest < ApplicationSystemTestCase
  def setup
    super
    @user = users(:participant)
    @user.update!(mobile_phone_confirmed_at: nil)
    enable_phone_confirmation

    @valid_auction_with_no_offers = auctions(:valid_without_offers)
    travel_to Time.parse('2010-07-05 10:31 +0000')

    sign_in(@user)
  end

  def teardown
    super
  end

  def test_phone_confirmation_is_sent_on_page_visit
    PhoneConfirmationJob.stub(:perform_later, nil, @user.id) do
      @user.reload
      visit new_user_phone_confirmation_path(@user.uuid)
      assert(page.has_text?('We sent a four digit code to +37255000002'))

      fill_in('phone_confirmation[confirmation_code]', with: @user.mobile_phone_confirmation_code)
      click_link_or_button('Submit')
      assert(
        page.has_css?('div.notice',
                      text: 'Your phone number has been confirmed. You can now submit offers.'))
    end
  end

  def test_user_cannot_submit_an_offer_without_phone_confirmation
    PhoneConfirmationJob.stub(:perform_later, nil, @user.id) do
      visit auction_path(@valid_auction_with_no_offers.uuid)
      assert(page.has_link?('Submit offer'))
      click_link('Submit offer')

      assert(page.has_css?('div.notice',
                           text: 'You need to confirm your phone number before making an offer'))

      fill_in('phone_confirmation[confirmation_code]', with: @user.mobile_phone_confirmation_code)
      click_link_or_button('Submit')

      visit auction_path(@valid_auction_with_no_offers.uuid)
      assert(page.has_link?('Submit offer'))
      click_link('Submit offer')

      fill_in('offer[price]', with: '5.12')
      click_link_or_button('Submit')

      assert(page.has_text?('Created successfully'))
    end
  end

  def enable_phone_confirmation
    setting = settings(:require_phone_confirmation)
    setting.update!(value: "true")
  end
end
