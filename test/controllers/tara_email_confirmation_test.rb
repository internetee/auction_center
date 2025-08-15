require 'test_helper'

class TaraEmailConfirmationTest < ActionDispatch::IntegrationTest
  def setup
    @tara_user = users(:participant)
    @tara_user.update!(
      provider: User::TARA_PROVIDER,
      uid: 'EE12345678901',
      confirmed_at: nil
    )
  end

  def test_tara_user_with_unconfirmed_email_can_access_profile
    sign_in @tara_user
    
    get user_path(@tara_user.uuid)
    assert_response :success
    
    # Check if the warning message is displayed
    assert_match 'Email confirmation required', response.body
  end

  def test_tara_user_with_unconfirmed_email_can_edit_profile
    sign_in @tara_user
    
    get edit_user_path(@tara_user.uuid)
    assert_response :success
    
    # Test that user can update their email
    patch user_path(@tara_user.uuid), params: {
      user: {
        email: 'newemail@example.com'
      }
    }
    
    # Should be able to update profile
    assert_response :redirect
    @tara_user.reload
    assert_equal 'newemail@example.com', @tara_user.unconfirmed_email || @tara_user.email
  end

  def test_tara_user_with_unconfirmed_email_cannot_create_offer
    sign_in @tara_user
    auction = auctions(:valid_without_offers)
    
    # Test that user cannot even access the new offer form
    get new_auction_offer_path(auction.uuid)
    assert_redirected_to user_path(@tara_user.uuid)
    assert_equal I18n.t('users.email_confirmation_required.action_blocked'), flash[:alert]
    
    # Test that user cannot create offer
    post auction_offers_path(auction.uuid), params: { 
      offer: { 
        auction_id: auction.id,
        user_id: @tara_user.id,
        price: 10.0
      }
    }
    
    # Should be redirected to profile page with error message
    assert_redirected_to user_path(@tara_user.uuid)
    assert_equal I18n.t('users.email_confirmation_required.action_blocked'), flash[:alert]
  end

  def test_tara_user_with_unconfirmed_email_cannot_pay_deposit
    sign_in @tara_user
    auction = auctions(:valid_without_offers)
    
    # Attempt to access deposit payment should be denied
    ability = Ability.new(@tara_user)
    assert ability.cannot?(:pay_deposit, auction)
  end

  def test_tara_user_with_confirmed_email_has_full_access
    @tara_user.confirm
    sign_in @tara_user
    
    get user_path(@tara_user.uuid)
    assert_response :success
    
    # Check that warning message is NOT displayed
    assert_no_match 'Email confirmation required', response.body
    
    # Should have full abilities
    ability = Ability.new(@tara_user)
    assert ability.can?(:manage, @tara_user)
    assert ability.can?(:create, Offer)
  end

  def test_regular_user_not_affected_by_tara_restrictions
    regular_user = users(:second_place_participant)
    regular_user.update!(provider: nil, uid: nil)
    
    sign_in regular_user
    
    ability = Ability.new(regular_user)
    # Regular users should have normal permissions regardless of email confirmation
    assert ability.can?(:manage, regular_user)
  end
end