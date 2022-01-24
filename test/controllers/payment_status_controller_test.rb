require "test_helper"

class PaymentStatusControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get payment_status_update_url
    assert_response :success
  end
end
