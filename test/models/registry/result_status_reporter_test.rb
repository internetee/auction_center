require "test_helper"

class ResultStatusReporterTest < ActiveSupport::TestCase
  def setup
    super

    @no_bids = results(:without_offers_nobody)
    @awaiting_payment = results(:with_invoice)
  end

  def teardown
    super

    clear_email_deliveries
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

  def test_call_does_not_report_updates_when_remote_id_is_missing
    @no_bids.auction.update!(remote_id: nil)

    instance = Registry::StatusReporter.new(@no_bids)
    refute(instance.call)
  end

  def test_call_sends_email_that_registration_code_is_now_available
    @awaiting_payment.update(status: Result.statuses[:payment_received])

    instance = Registry::StatusReporter.new(@awaiting_payment)

    body = { "id" => @awaiting_payment.auction.remote_id, "domain" => "with-invoice.test",
             "status" => "payment_received", "registration_code" => "some code" }

    with_successful_request(instance, body) do
      instance.call
      assert_equal(@awaiting_payment.last_remote_status, "payment_received")
      assert_equal(@awaiting_payment.registration_code, "some code")
      assert_equal(@awaiting_payment.last_response, body)

      email = ActionMailer::Base.deliveries.last
      assert_equal(["user@auction.test"], email.to)
      assert_equal("with-invoice.test registration code available", email.subject)
    end
  end

  def test_call_does_not_send_email_when_domain_has_not_be_registered
    @awaiting_payment.update(status: Result.statuses[:domain_not_registered])

    instance = Registry::StatusReporter.new(@awaiting_payment)

    body = { "id" => @awaiting_payment.auction.remote_id, "domain" => "with-invoice.test",
             "status" => "domain_not_registered", "registration_code" => "some code" }

    with_successful_request(instance, body) do
      instance.call
      assert_equal(@awaiting_payment.last_remote_status, "domain_not_registered")
      assert_equal(@awaiting_payment.registration_code, "some code")
      assert_equal(@awaiting_payment.last_response, body)

      email = ActionMailer::Base.deliveries.last
      refute(email)
    end
  end

  def test_call_updates_result_record
    instance = Registry::StatusReporter.new(@no_bids)

    body = { "id" => @no_bids.auction.remote_id, "domain" => "no-offers.test",
             "status" => "no_bids" }

    with_successful_request(instance, body) do
      instance.call
      assert_equal(@no_bids.last_remote_status, "no_bids")
      assert_equal(@no_bids.last_response, body)
    end
  end

  def test_call_updates_result_record_when_domain_is_not_registered_in_time
    @no_bids.update(status: Result.statuses[:domain_not_registered])

    instance = Registry::StatusReporter.new(@no_bids)

    body = { "id" => @no_bids.auction.remote_id, "domain" => "no-offers.test",
             "status" => "domain_not_registered" }

    with_successful_request(instance, body) do
      instance.call
      assert_equal(@no_bids.last_remote_status, "domain_not_registered")
      assert_equal(@no_bids.last_response, body)
    end
  end

  def test_call_raises_an_error_when_answer_is_not_200
    instance = Registry::StatusReporter.new(@no_bids)

    body = ""
    response = Minitest::Mock.new

    response.expect(:code, "401")
    response.expect(:code, "401")
    response.expect(:body, body)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      assert_raises(Registry::CommunicationError) do
        instance.call
      end
    end
  end

  def with_successful_request(instance, body, &block)
    response = Minitest::Mock.new

    response.expect(:code, "200")
    response.expect(:code, "200")
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      yield
    end
  end
end
