require 'test_helper'

class UserTaraEmailConfirmationTest < ActiveSupport::TestCase
  def setup
    @tara_user = User.new(
      email: 'test@example.com',
      provider: User::TARA_PROVIDER,
      uid: 'EE12345678901',
      identity_code: '12345678901',
      country_code: 'EE',
      given_names: 'Test',
      surname: 'User',
      password: Devise.friendly_token[0..20]
    )
    @tara_user.skip_confirmation_notification!
    @tara_user.save!
  end

  def test_tara_user_with_unconfirmed_email_returns_true_when_not_confirmed
    assert @tara_user.tara_user_with_unconfirmed_email?
  end

  def test_tara_user_with_unconfirmed_email_returns_false_when_confirmed
    @tara_user.confirm
    assert_not @tara_user.tara_user_with_unconfirmed_email?
  end

  def test_regular_user_with_unconfirmed_email_returns_false
    regular_user = User.new(
      email: 'regular@example.com',
      provider: nil,
      uid: nil,
      identity_code: '98765432101',
      country_code: 'EE',
      given_names: 'Regular',
      surname: 'User',
      mobile_phone: '+3725555555',
      password: 'password123',
      password_confirmation: 'password123'
    )
    regular_user.skip_confirmation_notification!
    regular_user.save!

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
    regular_user = User.new(
      email: 'regular@example.com',
      provider: nil,
      uid: nil,
      identity_code: '98765432101',
      country_code: 'EE',
      given_names: 'Regular',
      surname: 'User',
      mobile_phone: '+3725555555',
      password: 'password123',
      password_confirmation: 'password123'
    )
    regular_user.skip_confirmation_notification!
    regular_user.save!

    # Regular users must confirm email to authenticate
    assert_not regular_user.active_for_authentication?
  end
end