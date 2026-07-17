require 'test_helper'

class AuctionQueriesTest < ActiveSupport::TestCase
  def test_sorted_by_winning_offer_username_builds_join_subquery
    sql = Queries::Auction::SortedByWinningOfferUsername.call.to_sql
    assert_includes sql, 'offers_subquery'
    assert_includes sql, 'LEFT JOIN'
    assert_includes sql, 'SELECT MAX'
  end

  def test_with_max_offer_cents_for_english_auction_builds_join_subquery_without_user
    sql = Queries::Auction::WithMaxOfferCentsForEnglishAuction.call.to_sql
    assert_includes sql, 'offers_subquery'
    assert_includes sql, 'platform = 1'
    assert_includes sql, 'MAX(cents)'
  end

  def test_with_max_offer_cents_for_english_auction_interpolates_user_id_when_given
    user = users(:participant)
    sql = Queries::Auction::WithMaxOfferCentsForEnglishAuction.call(user: user).to_sql
    assert_includes sql, "user_id = #{user.id}"
  end
end
