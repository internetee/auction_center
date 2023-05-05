require 'application_system_test_case'

class RecaptchaOffersTest < ApplicationSystemTestCase
  def setup
    super

    @expired_auction = auctions(:expired)
    @valid_auction = auctions(:valid_with_offers)
    @valid_auction_with_no_offers = auctions(:valid_without_offers)
    @user = users(:participant)
    @omniauth_user = users(:signed_in_with_omniauth)
    @offer = offers(:minimum_offer)
    @expired_offer = offers(:expired_offer)

    travel_to Time.parse('2010-07-05 10:31 +0000').in_time_zone
  end

  def teardown
    super
  end

  def test_user_needs_to_fill_in_recaptcha_when_submitting_an_offer
    enable_recaptcha

    sign_in(@user)
    visit auction_path(@valid_auction_with_no_offers.uuid)

    with_recaptcha_test_keys do
      click_link('Bid!')

      fill_in('offer[price]', with: '5.12')
      select_from_dropdown('ACME Inc.', from: 'offer[billing_profile_id]')

      click_link_or_button('Submit')

      assert_text('reCAPTCHA verification failed, please try again.')
    end

    disable_recaptcha
  end

  def test_tara_user_does_not_need_captcha
    enable_recaptcha
    sign_in(@omniauth_user)

    visit auction_path(@valid_auction_with_no_offers.uuid)

    with_recaptcha_test_keys do
      click_link('Bid!')

      fill_in('offer[price]', with: '5.12')
      click_link_or_button('Submit')

      assert_text('Offer submitted successfully.')
    end

    disable_recaptcha
  end

  def test_recaptcha_skips_in_test_environment
    sign_in(@user)
    visit auction_path(@valid_auction_with_no_offers.uuid)
    click_link('Bid!')

    fill_in('offer[price]', with: '5.12')
    select_from_dropdown('ACME Inc.', from: 'offer[billing_profile_id]')
    click_link_or_button('Submit')

    assert_text('Offer submitted successfully.')
  end

  def with_recaptcha_test_keys
    Recaptcha.with_configuration(site_key: '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI',
                                 secret_key: '6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe') do
      yield
    end
  end

  def enable_recaptcha
    Recaptcha.configuration.skip_verify_env.delete('test')
  end

  def disable_recaptcha
    Recaptcha.configuration.skip_verify_env.push('test')
  end
end
