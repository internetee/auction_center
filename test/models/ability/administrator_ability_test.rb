require 'test_helper'

class AdministratorAbilityTest < ActiveSupport::TestCase
  def setup
    @administrator = users(:administrator)
    @participant = users(:participant)
    @administrator_ability = Ability.new(@administrator)
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

  def test_administrator_can_manage_auctions
    assert(@administrator_ability.can?(:manage, Auction))
  end

  def test_administrator_cannot_manage_offers
    refute(@administrator_ability.can?(:manage, Offer))
    assert(@administrator_ability.can?(:read, Offer))
  end

  def test_administrator_can_read_results
    assert(@administrator_ability.can?(:read, Result))
  end
end
