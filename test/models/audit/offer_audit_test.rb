require 'test_helper'

class OfferAuditTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    @offer = offers(:minimum_offer)
  end

  def teardown
    super

    travel_back
  end

  def test_creating_a_offer_creates_a_history_record
    offer = Offer.new(auction: auctions(:valid_with_offers),
                      user: users(:participant),
                      billing_profile: billing_profiles(:company),
                      cents: 1121)

    offer.save

    assert(audit_record = Audit::Offer.find_by(object_id: offer.id, action: 'INSERT'))
    assert_equal(offer.auction_id, audit_record.new_value['auction_id'])
  end

  def test_updating_a_offer_creates_a_history_record
    @offer.update!(cents: 4500)

    assert_equal(1, Audit::Offer.where(object_id: @offer.id, action: 'UPDATE').count)
    assert(audit_record = Audit::Offer.find_by(object_id: @offer.id, action: 'UPDATE'))
    assert_equal(@offer.cents, audit_record.new_value['cents'])
  end

  def test_deleting_a_offer_creates_a_history_record
    @offer.delete

    assert_equal(1, Audit::Offer.where(object_id: @offer.id, action: 'DELETE').count)
    assert(audit_record = Audit::Offer.find_by(object_id: @offer.id, action: 'DELETE'))
    assert_equal({}, audit_record.new_value)
  end

  def test_diff_method_returns_only_fields_that_are_different
    @offer.update!(cents: 4500)
    audit_record = Audit::Offer.find_by(object_id: @offer.id, action: 'UPDATE')

    %w[updated_at cents].each do |item|
      assert(audit_record.diff.key?(item))
    end

    assert_equal(2, audit_record.diff.length)
  end
end
