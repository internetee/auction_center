require 'test_helper'

class TaraEmailConfirmationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @tara_user = users(:participant)
    @tara_user.update!(
      provider: User::TARA_PROVIDER,
      uid: 'EE12345678901',
      confirmed_at: nil,
      roles: ['participant']
    )
  end

  def test_tara_user_with_unconfirmed_email_can_access_profile
    sign_in @tara_user
    
    get user_path(@tara_user.uuid)
    assert_response :success
    
    assert_match 'Email confirmation required', response.body
  end

  def test_tara_user_with_unconfirmed_email_cannot_create_offer
    sign_in @tara_user
    auction = auctions(:valid_without_offers)
    
    get new_auction_offer_path(auction.uuid)
    assert_redirected_to user_path(@tara_user.uuid)
    assert_equal I18n.t('users.email_confirmation_required.action_blocked'), flash[:alert]
    
    post auction_offers_path(auction.uuid), params: { 
      offer: { 
        auction_id: auction.id,
        user_id: @tara_user.id,
        price: 10.0
      }
    }
    
    assert_redirected_to user_path(@tara_user.uuid)
    assert_equal I18n.t('users.email_confirmation_required.action_blocked'), flash[:alert]
  end

  def test_tara_user_with_unconfirmed_email_cannot_pay_deposit
    sign_in @tara_user
    auction = auctions(:valid_without_offers)
    
    ability = Ability.new(@tara_user)
    assert ability.cannot?(:pay_deposit, auction)
  end

  def test_tara_user_with_confirmed_email_has_full_access
    @tara_user.confirm
    sign_in @tara_user
    
    get user_path(@tara_user.uuid)
    assert_response :success
    
    assert_no_match 'Email confirmation required', response.body
    
    ability = Ability.new(@tara_user)
    assert ability.can?(:manage, @tara_user)
    assert ability.can?(:create, Offer)
  end

  def test_regular_user_not_affected_by_tara_restrictions
    regular_user = users(:second_place_participant)
    regular_user.update!(provider: nil, uid: nil, mobile_phone: '+37255000003')
    
    sign_in regular_user
    
    ability = Ability.new(regular_user)
    assert ability.can?(:manage, regular_user)
  end
end