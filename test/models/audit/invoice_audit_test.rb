require 'test_helper'

class InvoiceAuditTest < ActiveSupport::TestCase
  def setup
    super

    @invoice = invoices(:orphaned)
    @result = results(:expired_participant)
    @user = users(:participant)
    @billing_profile = billing_profiles(:company)
  end

  def teardown
    super

    travel_back
  end

  def test_creating_a_invoice_creates_a_history_record
    invoice = Invoice.new(result: @result,
                          billing_profile: @billing_profile,
                          user: @user,
                          issue_date: Time.zone.today,
                          due_date: Time.zone.today + ApplicationSetting.payment_term,
                          cents: 1000)

    invoice.save!

    assert(audit_record = Audit::Invoice.find_by(object_id: invoice.id, action: 'INSERT'))
    assert_equal(invoice.cents, audit_record.new_value['cents'])
  end

  def test_updating_a_invoice_creates_a_history_record
    @invoice.cancelled!

    assert_equal(1, Audit::Invoice.where(object_id: @invoice.id, action: 'UPDATE').count)
    assert(audit_record = Audit::Invoice.find_by(object_id: @invoice.id, action: 'UPDATE'))
    assert_equal(Invoice.statuses[@invoice.status], audit_record.new_value['status'])
  end

  def test_deleting_a_invoice_creates_a_history_record
    @invoice.destroy

    assert_equal(1, Audit::Invoice.where(object_id: @invoice.id, action: 'DELETE').count)
    assert(audit_record = Audit::Invoice.find_by(object_id: @invoice.id, action: 'DELETE'))
    assert_equal({}, audit_record.new_value)
  end

  def test_diff_method_returns_only_fields_that_are_different
    @invoice.cancelled!
    audit_record = Audit::Invoice.find_by(object_id: @invoice.id, action: 'UPDATE')

    %w[updated_at status].each do |item|
      assert(audit_record.diff.key?(item))
    end

    assert_equal(2, audit_record.diff.length)
  end
end
