require "test_helper"

class DomainParticipateAuctionModelTest < ActiveSupport::TestCase
  setup do
    @auction = auctions(:english)
    @user = users(:participant)
  end

  def test_should_return_and_auction_name
    DomainParticipateAuction.create!(user: @user, auction: @auction)

    params = {}
    params[:search_string] = 'ish_auc'

    res = DomainParticipateAuction.search(params)

    assert_equal res[0].auction.domain_name, @auction.domain_name
  end

  def test_should_return_and_user_email
    DomainParticipateAuction.create!(user: @user, auction: @auction)

    params = {}
    params[:search_string] = 'user@au'

    res = DomainParticipateAuction.search(params)

    assert_equal res[0].user.email, @user.email
  end
end
