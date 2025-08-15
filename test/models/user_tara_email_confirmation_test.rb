require 'test_helper'

class UserTaraEmailConfirmationTest < ActiveSupport::TestCase
  def setup
    @tara_user = users(:signed_in_with_omniauth)
    @tara_user.update!(confirmed_at: nil)  # Make email unconfirmed for testing
  end

  def test_tara_user_with_unconfirmed_email_returns_true_when_not_confirmed
    assert @tara_user.tara_user_with_unconfirmed_email?
  end

  def test_tara_user_with_unconfirmed_email_returns_false_when_confirmed
    @tara_user.confirm
    assert_not @tara_user.tara_user_with_unconfirmed_email?
  end

  def test_regular_user_with_unconfirmed_email_returns_false
    regular_user = users(:participant)
    regular_user.update!(
      provider: nil,
      uid: nil,
      confirmed_at: nil
    )

    assert_not regular_user.tara_user_with_unconfirmed_email?
  end

  def test_ability_for_tara_user_with_unconfirmed_email
    ability = Ability.new(@tara_user)
    
    # Should be able to read and update their own profile
    assert ability.can?(:read, @tara_user)
    assert ability.can?(:update, @tara_user)
    
    # Should NOT be able to create offers
    assert ability.cannot?(:create, Offer)
    
    # Should NOT be able to pay deposit for auctions
    auction = auctions(:valid_with_offers)
    assert ability.cannot?(:pay_deposit, auction)
  end

  def test_ability_for_tara_user_with_confirmed_email
    @tara_user.confirm
    ability = Ability.new(@tara_user)
    
    # Should be able to manage their own profile
    assert ability.can?(:manage, @tara_user)
    
    # Should be able to manage their own offers
    assert ability.can?(:manage, Offer.new(user: @tara_user))
    
    # Should be able to pay deposit for auctions (if not banned)
    auction = auctions(:valid_with_offers)
    assert ability.can?(:pay_deposit, auction)
  end

  def test_tara_user_can_authenticate_without_email_confirmation
    # TARA users should be able to authenticate even without confirmed email
    assert @tara_user.active_for_authentication?
  end

  def test_regular_user_cannot_authenticate_without_email_confirmation
    regular_user = users(:second_place_participant)
    regular_user.update!(
      provider: nil,
      uid: nil,
      confirmed_at: nil,
      mobile_phone: '+37255000099'
    )

    # Regular users must confirm email to authenticate
    assert_not regular_user.active_for_authentication?
  end
end