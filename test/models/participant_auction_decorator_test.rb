require 'test_helper'

class ParticipantAuctionDecoratorTest < ActiveSupport::TestCase
  def setup
    super

    @persisted_auction = auctions(:valid_with_offers)
    @user = users(:participant)
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  def test_class_methods_do_not_leak_to_auction_class
    assert(ParticipantAuctionDecorator.column_names.include?('users_offer_cents'))
    assert_not(Auction.column_names.include?('user_offers_cents'))
  end

  def test_table_names_are_the_same_as_auction
    assert_equal(ParticipantAuctionDecorator.table_name, Auction.table_name)
  end

  def test_with_highest_offers_scope_returns_a_relation_of_auctions
    auctions = ParticipantAuctionDecorator.with_user_offers(@user)

    decorated_auction = auctions.find_by(auctions: { domain_name: 'with-offers.test' })
    assert_equal(@persisted_auction.id, decorated_auction.id)
    assert_equal(@persisted_auction.uuid, decorated_auction.uuid)
    assert_equal(@persisted_auction.domain_name, decorated_auction.domain_name)
    assert_equal(@persisted_auction.starts_at, decorated_auction.starts_at)
    assert_equal(@persisted_auction.ends_at, decorated_auction.ends_at)
  end

  def test_instance_implements_users_price_method
    auctions = ParticipantAuctionDecorator.with_user_offers(@user)
    decorated_auction = ParticipantAuctionDecorator.new(
      auctions.find_by(auctions: { domain_name: 'with-offers.test' })
    )
    assert_equal(Money.new(5000, Setting.find_by(code: 'auction_currency').retrieve), decorated_auction.users_price)
  end
end
