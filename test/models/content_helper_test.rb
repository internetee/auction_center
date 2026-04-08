require 'test_helper'

class ContentHelperTest < ActiveSupport::TestCase
  def test_minimum_offer_reads_setting
    setting_double = Object.new
    setting_double.define_singleton_method(:retrieve) { 1234 }

    Setting.stub(:find_by, setting_double) do
      assert_equal 1234, ContentHelper.minimum_offer
    end
  end

  def test_create_invoice_updates_dates_and_status
    invoice_double = Object.new
    captured = {}
    invoice_double.define_singleton_method(:update!) { |attrs| captured = attrs }

    creator_double = Object.new
    creator_double.define_singleton_method(:call) { invoice_double }

    InvoiceCreator.stub(:new, ->(*) { creator_double }) do
      returned = ContentHelper.create_invoice(Object.new)
      assert_equal invoice_double, returned
    end

    assert_equal Invoice.statuses[:issued], captured[:status]
    assert captured[:issue_date].present?
    assert captured[:due_date].present?
  end
end
