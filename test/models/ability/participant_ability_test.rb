require 'test_helper'

class ParticipantAbilityTest < ActiveSupport::TestCase
  def setup
    @participant = users(:participant)
    @participant_ability = Ability.new(@participant)
  end

  def test_user_can_edit_their_own_profile
    assert(@participant_ability.can?(:edit?, @participant))
    assert(@participant_ability.can?(:read?, @participant))
    assert(@participant_ability.can?(:update?, @participant))

    refute(@participant_ability.can?(:destroy, User.new))
    refute(@participant_ability.can?(:edit, User.new))
  end

  def test_user_can_edit_their_own_billing_profiles
    assert(@participant_ability.can?(:edit?, BillingProfile.new(user_id: @participant.id)))
    assert(@participant_ability.can?(:read?, BillingProfile.new(user_id: @participant.id)))
    assert(@participant_ability.can?(:update?, BillingProfile.new(user_id: @participant.id)))
    assert(@participant_ability.can?(:delete?, BillingProfile.new(user_id: @participant.id)))

    refute(@participant_ability.can?(:destroy, BillingProfile.new()))
    refute(@participant_ability.can?(:edit, BillingProfile.new()))
  end

  def test_participant_can_manage_their_own_offers
    assert(@participant_ability.can?(:edit?, Offer.new(user_id: @participant.id)))
    assert(@participant_ability.can?(:read?, Offer.new(user_id: @participant.id)))
    assert(@participant_ability.can?(:update?, Offer.new(user_id: @participant.id)))
    assert(@participant_ability.can?(:delete?, Offer.new(user_id: @participant.id)))

    refute(@participant_ability.can?(:destroy, Offer.new()))
    refute(@participant_ability.can?(:edit, Offer.new()))
  end
end
