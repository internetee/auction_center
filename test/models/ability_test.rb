require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  def setup
    anonymous_user = User.new
    @participant = users(:participant)
    @administrator = users(:administrator)

    @anonymous_ability = Ability.new(anonymous_user)
    @participant_ability = Ability.new(@participant)
    @administrator_ability = Ability.new(@administrator)
  end

  def test_user_can_edit_their_own_profile
    assert(@participant_ability.can?(:edit?, @participant))
    assert(@participant_ability.can?(:read?, @participant))
    assert(@participant_ability.can?(:update?, @participant))

    refute(@participant_ability.can?(:destroy, User.new))
    refute(@participant_ability.can?(:edit, User.new))
  end

  def test_administrator_can_edit_any_user
    assert(@administrator_ability.can?(:edit?, @participant))
    assert(@administrator_ability.can?(:read?, @participant))
    assert(@administrator_ability.can?(:update?, @participant))
    assert(@administrator_ability.can?(:destroy, User.new))
    assert(@administrator_ability.can?(:edit, User.new))
  end

  def test_administrator_can_read_audit_records
    assert(@administrator_ability.can?(:read, Audit::Auction))
    assert(@administrator_ability.can?(:read, Audit::BillingProfile))
    assert(@administrator_ability.can?(:read, Audit::User))
    assert(@administrator_ability.can?(:read, Audit::Setting))

    refute(@administrator_ability.can?(:create, Audit::Auction))
    refute(@administrator_ability.can?(:create, Audit::BillingProfile))
    refute(@administrator_ability.can?(:create, Audit::User))
    refute(@administrator_ability.can?(:create, Audit::Setting))
  end

  def test_administrator_can_edit_settings
    assert(@administrator_ability.can?(:read, Setting))
    assert(@administrator_ability.can?(:update, Setting))
    assert(@administrator_ability.can?(:edit, Setting))

    refute(@administrator_ability.can?(:created, Setting))
    refute(@administrator_ability.can?(:destroy, Setting))
  end

  def test_user_can_edit_their_own_billing_profiles
    assert(@participant_ability.can?(:edit?, BillingProfile.new(user_id: @participant.id)))
    assert(@participant_ability.can?(:read?, BillingProfile.new(user_id: @participant.id)))
    assert(@participant_ability.can?(:update?, BillingProfile.new(user_id: @participant.id)))
    assert(@participant_ability.can?(:delete?, BillingProfile.new(user_id: @participant.id)))

    refute(@participant_ability.can?(:destroy, BillingProfile.new()))
    refute(@participant_ability.can?(:edit, BillingProfile.new()))
  end

  def test_anonymous_user_can_read_auctions
    assert(@anonymous_ability.can?(:read, Auction))
    assert(@participant_ability.can?(:read, Auction))
    assert(@administrator_ability.can?(:read, Auction))
  end

  def test_administrator_can_manage_auctions
    refute(@anonymous_ability.can?(:manage, Auction))
    refute(@participant_ability.can?(:manage, Auction))
    assert(@administrator_ability.can?(:manage, Auction))
  end
end
