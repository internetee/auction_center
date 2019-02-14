require 'test_helper'

class ResultStatusReporterTest < ActiveSupport::TestCase
  def setup
    super

    @no_bids = results(:without_offers_nobody)
  end

  def teardown
    super
  end

  def test_result_variable
    instance = Registry::StatusReporter.new(@no_bids)
    assert_equal(@no_bids, instance.result)
  end

  def test_does_nothing_if_status_has_already_been_reported
    @no_bids.update!(last_remote_status: :no_bids)
    instance = Registry::StatusReporter.new(@no_bids)
    refute(instance.call)
  end

  def test_call_does_not_report_updates_when_domain_is_registered
    @no_bids.update!(status: :domain_registered)
    instance = Registry::StatusReporter.new(@no_bids)
    refute(instance.call)
  end

  def test_call_raises_an_error_when_answer_is_not_200
    instance = Registry::StatusReporter.new(@no_bids)

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

  def test_call_updates_result_record
    instance = Registry::StatusReporter.new(@no_bids)

    body = { "id" => @no_bids.auction.remote_id, "domain" => 'no-offers.test',
             "status" => "no_bids" }

    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call
      assert_equal(@no_bids.last_remote_status, 'no_bids')
      assert_equal(@no_bids.last_response, body)
    end
  end

  def test_call_updates_result_record_when_domain_is_not_registered_in_time
    @no_bids.update(status: Result.statuses[:domain_not_registered])

    instance = Registry::StatusReporter.new(@no_bids)

    body = { "id" => @no_bids.auction.remote_id, "domain" => 'no-offers.test',
             "status" => "domain_not_registered" }

    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call
      assert_equal(@no_bids.last_remote_status, 'domain_not_registered')
      assert_equal(@no_bids.last_response, body)
    end
  end
end
