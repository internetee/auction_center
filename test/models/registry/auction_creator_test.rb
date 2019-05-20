require 'test_helper'

class RegistryAuctionCreatorTest < ActiveSupport::TestCase
  # Without this helper, the test fail on trying to set wait time on Job
  # Registry::AuctionCreator#send_wishlist_notification(domain_name, remote_id)
  # app/models/registry/auction_creator:56
  include ActiveJob::TestHelper

  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
  end

  def teardown
    super

    travel_back
  end

  def test_call_raises_an_error_when_answer_is_not_200
    instance = Registry::AuctionCreator.new

    body = ""
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

  def test_call_creates_auctions_that_start_at_midnight_in_2_days
    instance = Registry::AuctionCreator.new

    body = [{"id" => "cdf377a6-8797-40d8-90a1-b7aadfddc8e3", "domain" => "shop.test",
             "status" => "started"},
            {"id" => "e561ce42-9003-47b4-af73-8092fffe6591", "domain" => "foo.test",
             "status" => "started"},
            {"id" => "1c92c1a9-4b5b-466b-92bf-05bbc3bca5e8", "domain" => "fo.test",
             "status" => "started"}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      assert_changes('Auction.count', 3) do
        instance.call
        example_auction = Auction.find_by(remote_id: "cdf377a6-8797-40d8-90a1-b7aadfddc8e3")
        assert_equal(Date.tomorrow.to_datetime, example_auction.starts_at)
        assert_equal(Date.tomorrow.to_datetime + 1.day, example_auction.ends_at)
      end
    end
  end

  def test_call_creates_auctions_that_end_at_the_end_of_day
    setting = settings(:auctions_start_at)
    setting.update!(value: 'false')

    auction_duration = settings(:auction_duration)
    auction_duration.update!(value: 'end_of_day')

    instance = Registry::AuctionCreator.new

    body = [{"id" => "cdf377a6-8797-40d8-90a1-b7aadfddc8e3", "domain" => "shop.test",
             "status" => "started"},
            {"id" => "e561ce42-9003-47b4-af73-8092fffe6591", "domain" => "foo.test",
             "status" => "started"},
            {"id" => "1c92c1a9-4b5b-466b-92bf-05bbc3bca5e8", "domain" => "fo.test",
             "status" => "started"}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      assert_changes('Auction.count', 3) do
        instance.call
        example_auction = Auction.find_by(remote_id: "cdf377a6-8797-40d8-90a1-b7aadfddc8e3")
        assert_equal(Time.now + 1.minute, example_auction.starts_at)
        assert_equal((Date.tomorrow.to_datetime - 1.second), example_auction.ends_at)
      end
    end  end

  def test_call_creates_auctions_that_start_in_1_minute
    setting = settings(:auctions_start_at)
    setting.update!(value: 'false')

    instance = Registry::AuctionCreator.new

    body = [{"id" => "cdf377a6-8797-40d8-90a1-b7aadfddc8e3", "domain" => "shop.test",
             "status" => "started"},
            {"id" => "e561ce42-9003-47b4-af73-8092fffe6591", "domain" => "foo.test",
             "status" => "started"},
            {"id" => "1c92c1a9-4b5b-466b-92bf-05bbc3bca5e8", "domain" => "fo.test",
             "status" => "started"}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      assert_changes('Auction.count', 3) do
        instance.call
        example_auction = Auction.find_by(remote_id: "cdf377a6-8797-40d8-90a1-b7aadfddc8e3")
        assert_equal(Time.now + 1.minute, example_auction.starts_at)
        assert_equal(Time.now + 1.minute + 1.day, example_auction.ends_at)
      end
    end
  end
end
