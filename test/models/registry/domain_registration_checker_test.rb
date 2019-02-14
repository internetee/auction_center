require 'test_helper'

class DomainRegistrationCheckerTest < ActiveSupport::TestCase
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')

    @result = results(:expired_participant)
  end

  def teardown
    super

    travel_back
  end

  def test_call_raises_an_error_when_answer_is_not_200
    instance = Registry::RegistrationChecker.new(@result)

    body = ''
    response = Minitest::Mock.new

    response.expect(:code, '401')
    response.expect(:code, '401')
    response.expect(:body, body)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      assert_raises(Registry::CommunicationError) do
        instance.call
      end
    end
  end

  def test_call_updates_result_record_to_domain_registered
    instance = Registry::RegistrationChecker.new(@result)

    body = { "id" => "f15f032d-2f6b-4b87-be29-5edb25e9e4d2",
             "domain" => "expired.test",
             "status" => "domain_registered" }

    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call
      assert_equal(@result.status, 'domain_registered')
      assert_equal(@result.last_response, body)
    end
  end

  def test_call_updates_result_record_to_domain_not_registered
    @result.update!(created_at: Time.now)
    travel_back

    instance = Registry::RegistrationChecker.new(@result)

    body = { "id" => "f15f032d-2f6b-4b87-be29-5edb25e9e4d2",
             "domain" => "expired.test",
             "status" => "payment_received" }

    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call
      assert_equal(@result.status, 'domain_not_registered')
      assert_equal(@result.last_response, body)
    end
  end
end
