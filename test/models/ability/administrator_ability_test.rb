require 'test_helper'

class AdministratorAbilityTest < ActiveSupport::TestCase
  def setup
    @administrator = users(:administrator)
    @participant = users(:participant)
    @administrator_ability = Ability.new(@administrator)
  end

  def test_administrator_can_edit_any_user
    assert(@administrator_ability.can?(:read?, @participant))
    assert(@administrator_ability.can?(:update?, @participant))
    assert(@administrator_ability.can?(:destroy, User.new))
    assert(@administrator_ability.can?(:edit, User.new))
  end

  def test_administrator_can_read_audit_records
    assert(@administrator_ability.can?(:read, Audit::Auction))
    assert(@administrator_ability.can?(:read, Audit::BillingProfile))
    assert(@administrator_ability.can?(:read, Audit::Ban))
    assert(@administrator_ability.can?(:read, Audit::User))
    assert(@administrator_ability.can?(:read, Audit::ApplicationSettingFormat))
    assert(@administrator_ability.can?(:read, Audit::Invoice))
    assert(@administrator_ability.can?(:read, Audit::InvoiceItem))
    assert(@administrator_ability.can?(:read, Audit::Result))
    assert(@administrator_ability.can?(:read, Audit::PaymentOrder))

    assert_not(@administrator_ability.can?(:create, Audit::Auction))
    assert_not(@administrator_ability.can?(:create, Audit::BillingProfile))
    assert_not(@administrator_ability.can?(:create, Audit::Ban))
    assert_not(@administrator_ability.can?(:create, Audit::User))
    assert_not(@administrator_ability.can?(:create, Audit::ApplicationSettingFormat))
    assert_not(@administrator_ability.can?(:create, Audit::Invoice))
    assert_not(@administrator_ability.can?(:create, Audit::InvoiceItem))
    assert_not(@administrator_ability.can?(:create, Audit::Result))
    assert_not(@administrator_ability.can?(:create, Audit::PaymentOrder))
  end

  def test_administrator_can_edit_settings
    assert(@administrator_ability.can?(:read, ApplicationSetting))
    assert(@administrator_ability.can?(:update, ApplicationSetting))

    assert_not(@administrator_ability.can?(:create, ApplicationSetting))
    assert_not(@administrator_ability.can?(:destroy, ApplicationSetting))
  end

  def test_administrator_can_manage_auctions
    assert(@administrator_ability.can?(:manage, Auction))
  end

  def test_administrator_cannot_manage_offers
    assert_not(@administrator_ability.can?(:manage, Offer))
    assert(@administrator_ability.can?(:read, Offer))
  end

  def test_administrator_can_read_results
    assert(@administrator_ability.can?(:read, Result))
  end

  def test_administrator_can_read_invoices
    assert(@administrator_ability.can?(:read, Invoice))
    assert(@administrator_ability.can?(:read, InvoiceItem))
    assert(@administrator_ability.can?(:read, PaymentOrder))
  end

  def test_administrator_can_update_invoices
    assert(@administrator_ability.can?(:update, Invoice))
    assert(@administrator_ability.cannot?(:create, Invoice))
  end

  def test_administrator_can_create_job_runs
    assert(@administrator_ability.can?(:read, Job))
    assert(@administrator_ability.can?(:create, Job))
  end

  def test_administrator_can_manage_bans
    assert(@administrator_ability.can?(:manage, Ban))
  end

  def test_administrator_cannot_manage_phone_number_confirmations
    assert(@administrator_ability.can?(:manage, PhoneConfirmation.new(@administrator)))
    assert_not(@administrator_ability.can?(:manage, PhoneConfirmation.new(@participant)))
  end
end
