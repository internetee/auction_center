require 'test_helper'

class AdminFinishedAuctionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveSupport::Testing::TimeHelpers

  def setup
    @admin = users(:administrator)
    @participant = users(:participant)
  end

  def sign_in_as(user)
    sign_in user
  end

  def travel_to_time(time_str)
    travel_to Time.parse(time_str).in_time_zone do
      yield
    end
  end

  def test_index_renders_for_administrator
    sign_in_as(@admin)

    travel_to_time('2000-01-01 12:00 +0000') do
      get admin_finished_auctions_index_path
    end

    assert_response :ok
    assert_includes response.body, 'expired.test'
  end

  def test_index_redirects_non_admin_user
    sign_in_as(@participant)

    get admin_finished_auctions_index_path

    assert_redirected_to root_path
  end
end
