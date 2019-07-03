require 'test_helper'

class DomainRegistrationCheckJobTest < ActiveJob::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    @result = results(:expired_participant)
    @result.update!(status: Result.statuses[:payment_received])
  end

  def teardown
    super

    travel_back
  end

  def test_perform_now
    mock = Minitest::Mock.new
    mock.expect(:call, @result)
    body = { 'id' => @result.auction.remote_id, 'domain' => 'expired.test',
             'status' => 'domain_registered' }

    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [Net::HTTP::Get])

    Net::HTTP.stub(:start, response, http) do
      DomainRegistrationCheckJob.perform_now
      @result.reload
      assert_equal(@result.status, 'domain_registered')
      assert_equal(@result.last_response, body)
    end
  end

  def test_needs_to_run_depends_on_a_scope
    DomainRegistrationCheckJob.stub(:registry_integration_enabled?, true) do
      assert(DomainRegistrationCheckJob.needs_to_run?)

      @result.update!(status: Result.statuses[:awaiting_payment])
      assert_not(DomainRegistrationCheckJob.needs_to_run?)
    end
  end
end
