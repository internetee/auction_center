require 'test_helper'

class ResultAuditTest < ActiveSupport::TestCase
  def setup
    super

    @result = results(:expired_participant)
    @auction = auctions(:valid_with_offers)
    @user = users(:participant)
  end

  def teardown
    super

    travel_back
  end

  def test_creating_a_result_creates_a_history_record
    result = Result.new(auction: @auction, sold: true, user: @user, cents: 400)
    result.save

    assert(audit_record = Audit::Result.find_by(object_id: result.id, action: 'INSERT'))
    assert_equal(result.cents, audit_record.new_value['cents'])
  end

  def test_updating_a_result_creates_a_history_record
    @result.update!(cents: 2000)

    assert_equal(1, Audit::Result.where(object_id: @result.id, action: 'UPDATE').count)
    assert(audit_record = Audit::Result.find_by(object_id: @result.id, action: 'UPDATE'))
    assert_equal(@result.cents, audit_record.new_value['cents'])
  end

  def test_deleting_a_result_creates_a_history_record
    @result.delete

    assert_equal(1, Audit::Result.where(object_id: @result.id, action: 'DELETE').count)
    assert(audit_record = Audit::Result.find_by(object_id: @result.id, action: 'DELETE'))
    assert_equal({}, audit_record.new_value)
  end

  def test_diff_method_returns_only_fields_that_are_different
    @result.update!(cents: 5000)
    audit_record = Audit::Result.find_by(object_id: @result.id, action: 'UPDATE')

    %w[updated_at cents].each do |item|
      assert(audit_record.diff.key?(item))
    end

    assert_equal(2, audit_record.diff.length)
  end
end
