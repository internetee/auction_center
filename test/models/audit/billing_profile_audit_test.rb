require 'test_helper'

class BillingProfileAuditTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    @billing_profile = billing_profiles(:private_person)
    @user = users(:participant)
  end

  def teardown
    super

    travel_back
  end

  def test_creating_a_billing_profile_creates_a_history_record
    billing_profile = BillingProfile.new(user: @user,
                                         name: 'New Billing Profile',
                                         vat_code: '1234567890',
                                         street: 'New Street 11',
                                         city: 'London',
                                         postal_code: 'NW1 6XE',
                                         country_code: 'GB')
    billing_profile.save(validate: false)

    assert(audit_record = Audit::BillingProfile.find_by(object_id: billing_profile.id, action: 'INSERT'))
    assert_equal(billing_profile.name, audit_record.new_value['name'])
  end

  def test_updating_a_billing_profile_creates_a_history_record
    @billing_profile.update!(city: 'Coventry')

    assert_equal(1, Audit::BillingProfile.where(object_id: @billing_profile.id, action: 'UPDATE').count)
    assert(audit_record = Audit::BillingProfile.find_by(object_id: @billing_profile.id, action: 'UPDATE'))
    assert_equal(@billing_profile.city, audit_record.new_value['city'])
  end

  def test_deleting_a_billing_profile_creates_a_history_record
    @billing_profile.delete

    assert_equal(1, Audit::BillingProfile.where(object_id: @billing_profile.id, action: 'DELETE').count)
    assert(audit_record = Audit::BillingProfile.find_by(object_id: @billing_profile.id, action: 'DELETE'))
    assert_equal({}, audit_record.new_value)
  end

  def test_diff_method_returns_only_fields_that_are_different
    @billing_profile.update!(name: 'New Name')
    audit_record = Audit::BillingProfile.find_by(object_id: @billing_profile.id, action: 'UPDATE')

    %w[updated_at name].each do |item|
      assert(audit_record.diff.key?(item))
    end

    assert_equal(2, audit_record.diff.length)
  end
end
