require 'test_helper'

class ResultStatusUpdateJobTest < ActiveJob::TestCase
  def setup
    super

    @result = results(:without_offers_nobody)
  end

  def test_perform_now
    mock = Minitest::Mock.new
    mock.expect(:call, @result)
    body = { "id" => @result.auction.remote_id, "domain" => 'no-offers.test',
            "status" => "no_bids" }

    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [Net::HTTP::Put])

    Net::HTTP.stub(:start, response, http) do
      ResultStatusUpdateJob.perform_now
      @result.reload
      assert_equal(@result.last_reported_status, 'no_bids')
      assert_equal(@result.last_response, body)
    end
  end

  def test_needs_to_run_depends_on_a_scope
    ResultStatusUpdateJob.stub(:registry_integration_enabled, true) do
      assert(ResultStatusUpdateJob.needs_to_run?)

      @result.update!(last_reported_status: @result.status)
      refute(ResultStatusUpdateJob.needs_to_run?)
    end
  end
end
