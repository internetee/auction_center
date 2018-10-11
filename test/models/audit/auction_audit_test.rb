require 'test_helper'

class AuctionAuditTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
  end

  def teardown
    super

    travel_back
  end

  def test_creating_a_auction_creates_a_history_record
    auction = Auction.new(domain_name: 'id.test', start_at: Time.now, ends_at: Time.now + 2.days)
  end

  def test_updating_a_auction_creates_a_history_record
  end

  def test_deleting_a_auction_creates_a_history_record
  end

  def test_diff_method_returns_only_fields_that_are_different
  end
end
