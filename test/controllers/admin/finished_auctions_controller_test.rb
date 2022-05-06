require "test_helper"

class Admin::FinishedAuctionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_finished_auctions_index_url
    assert_response :success
  end
end
