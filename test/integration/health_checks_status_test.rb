require 'test_helper'

class HealthChecksStatusTest < ActionDispatch::IntegrationTest
  def test_status_page_renders
    pdf_mock = Minitest::Mock.new
    pdf_mock.expect(:run, {
      'default' => { success: true, message: nil, time: 'now' }
    })

    ApplicationHealthCheck::InternalCheck.stub(:new, pdf_mock) do
      get '/status'
    end

    assert_response :ok
    assert_includes response.body, 'health-check-table'
  end
end
