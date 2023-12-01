require 'test_helper'

class UserAuditTest < ActiveSupport::TestCase
  def setup
    stub_request(:any, /eis_billing_system/)
      .to_return(status: 200, body: "{\"reference_number\":\"#{rand(111..999)}\"}", headers: {})

    @user = users(:participant)
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_creating_a_user_creates_a_history_record
    user = User.new(given_names: 'New user', surname: 'Surname', password: 'password',
                    password_confirmation: 'password', mobile_phone: '+372500100300',
                    email: 'user-email@auction.test', country_code: 'EE',
                    identity_code: '51007050077', accepts_terms_and_conditions: true)
    user.save

    assert(audit_record = Audit::User.find_by(object_id: user.id, action: 'INSERT'))
    assert_equal(user.given_names, audit_record.new_value['given_names'])
  end

  def test_updating_a_user_creates_a_history_record
    @user.update!(email: 'new-email@auction.test')

    assert_equal(1, Audit::User.where(object_id: @user.id, action: 'UPDATE').count)
    assert(audit_record = Audit::User.find_by(object_id: @user.id, action: 'UPDATE'))
    assert_equal(@user.email, audit_record.new_value['email'])
  end

  def test_deleting_a_user_creates_a_history_record
    @user.destroy

    assert_equal(1, Audit::User.where(object_id: @user.id, action: 'DELETE').count)
    assert(audit_record = Audit::User.find_by(object_id: @user.id, action: 'DELETE'))
    assert_equal({}, audit_record.new_value)
  end

  def test_diff_method_returns_only_fields_that_are_different
    @user.update!(given_names: 'New Name')
    audit_record = Audit::User.find_by(object_id: @user.id, action: 'UPDATE')

    %w[updated_at given_names].each do |item|
      assert(audit_record.diff.key?(item))
    end

    assert_equal(2, audit_record.diff.length)
  end
end
