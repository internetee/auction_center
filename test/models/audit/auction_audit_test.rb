require 'test_helper'

class AuctionAuditTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
    @auction = auctions(:id_test)
  end

  def teardown
    super

    travel_back
  end

  def test_creating_a_auction_creates_a_history_record
    auction = Auction.new(domain_name: 'id.test',
                          ends_at: Time.now + 2.days)

    auction.save

    assert(audit_record = Audit::Auction.find_by(object_id: auction.id, action: 'INSERT'))
    assert_equal(auction.domain_name, audit_record.new_value['domain_name'])
  end

  def test_updating_a_auction_creates_a_history_record
    @auction.update!(domain_name: 'new-domain.test')

    assert_equal(1, Audit::Auction.where(object_id: @auction.id, action: 'UPDATE').count)
    assert(audit_record = Audit::Auction.find_by(object_id: @auction.id, action: 'UPDATE'))
    assert_equal(@auction.domain_name, audit_record.new_value['domain_name'])
  end

  def test_deleting_a_auction_creates_a_history_record
    @auction.delete

    assert_equal(1, Audit::Auction.where(object_id: @auction.id, action: 'DELETE').count)
    assert(audit_record = Audit::Auction.find_by(object_id: @auction.id, action: 'DELETE'))
    assert_equal({}, audit_record.new_value)
  end

  def test_diff_method_returns_only_fields_that_are_different
    @auction.update!(domain_name: 'new-domain.test')
    audit_record = Audit::Auction.find_by(object_id: @auction.id, action: 'UPDATE')

    %w[updated_at domain_name].each do |item|
      assert(audit_record.diff.key?(item))
    end

    assert_equal(2, audit_record.diff.length)
  end
end
