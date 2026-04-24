require 'test_helper'

class HistoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
    @auction = auctions(:expired)
    sign_in @user
  end

  def test_index_lists_finished_auctions
    get histories_path

    assert_response :ok
    assert_includes response.body, @auction.domain_name
  end
end
