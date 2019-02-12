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
    instance = ResultStatusReporter.new(@no_bids)
    assert_equal(@no_bids, instance.result)
  end

  def test_does_nothing_if_status_has_already_been_reported
    @no_bids.update!(last_reported_status: :no_bids)
    instance = ResultStatusReporter.new(@no_bids)
    refute(instance.call)
  end

  def test_call_raises_an_error_when_answer_is_not_200
    instance = ResultStatusReporter.new(@no_bids)

    body = ''
    response = Minitest::Mock.new

    response.expect(:code, '401')
    response.expect(:code, '401')
    response.expect(:body, body)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      assert_raises(Errors::StatusReportFailed) do
        instance.call
      end
    end
  end

  def test_call_updates_result_record
    instance = ResultStatusReporter.new(@no_bids)

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
      assert_equal(@no_bids.last_reported_status, 'no_bids')
      assert_equal(@no_bids.last_response, body)
    end
  end
end
