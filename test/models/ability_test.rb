require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  def setup
    @participant = users(:user)
    @administrator = users(:administrator)

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
    assert(@administrator_ability.can?(:read, Audit::User))
    refute(@administrator_ability.can?(:create, Audit::User))
  end

  def test_administrator_can_edit_settings
    assert(@administrator_ability.can?(:read, Setting))
    assert(@administrator_ability.can?(:update, Setting))
    assert(@administrator_ability.can?(:edit, Setting))

    refute(@administrator_ability.can?(:created, Setting))
    refute(@administrator_ability.can?(:destroy, Setting))
  end
end
