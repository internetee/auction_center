require 'test_helper'

class DomainParticipateAuctionTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @administrator = users(:administrator)
    @auction = auctions(:english)

    sign_in @administrator
  end

  def test_should_open_the_page
    get admin_paid_deposits_path

    assert_equal response.status, 200
  end
end
