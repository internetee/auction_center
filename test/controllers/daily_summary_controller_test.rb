require "test_helper"

class DailySummaryControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get daily_summary_update_url
    assert_response :success
  end
end
