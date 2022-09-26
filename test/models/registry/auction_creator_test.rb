require 'test_helper'

class RegistryAuctionCreatorTest < ActiveSupport::TestCase
  # Without this helper, the test fail on trying to set wait time on Job
  # Registry::AuctionCreator#send_wishlist_notification(domain_name, remote_id)
  # app/models/registry/auction_creator:56
  include ActiveJob::TestHelper

  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  def test_call_raises_an_error_when_answer_is_not_200
    instance = Registry::AuctionCreator.new

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

  def test_call_creates_auctions_that_start_at_midnight_in_2_days
    instance = Registry::AuctionCreator.new

    body = [{ 'id' => 'cdf377a6-8797-40d8-90a1-b7aadfddc8e3', 'domain' => 'shop.test',
              'status' => 'started' },
            { 'id' => 'e561ce42-9003-47b4-af73-8092fffe6591', 'domain' => 'foo.test',
              'status' => 'started' },
            { 'id' => '1c92c1a9-4b5b-466b-92bf-05bbc3bca5e8', 'domain' => 'fo.test',
              'status' => 'started' }]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      assert_changes('Auction.count', 3) do
        instance.call
        example_auction = Auction.find_by(remote_id: 'cdf377a6-8797-40d8-90a1-b7aadfddc8e3')
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

    body = [{ 'id' => 'cdf377a6-8797-40d8-90a1-b7aadfddc8e3', 'domain' => 'shop.test',
              'status' => 'started' },
            { 'id' => 'e561ce42-9003-47b4-af73-8092fffe6591', 'domain' => 'foo.test',
              'status' => 'started' },
            { 'id' => '1c92c1a9-4b5b-466b-92bf-05bbc3bca5e8', 'domain' => 'fo.test',
              'status' => 'started' }]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      assert_changes('Auction.count', 3) do
        instance.call
        example_auction = Auction.find_by(remote_id: 'cdf377a6-8797-40d8-90a1-b7aadfddc8e3')
        assert_equal(Time.now.in_time_zone + 1.minute, example_auction.starts_at)
        assert_equal((Date.tomorrow.to_datetime - 1.second), example_auction.ends_at)
      end
    end end

  def test_call_creates_auctions_that_start_in_1_minute
    setting = settings(:auctions_start_at)
    setting.update!(value: 'false')

    instance = Registry::AuctionCreator.new

    body = [{ 'id' => 'cdf377a6-8797-40d8-90a1-b7aadfddc8e3', 'domain' => 'shop.test',
              'status' => 'started' },
            { 'id' => 'e561ce42-9003-47b4-af73-8092fffe6591', 'domain' => 'foo.test',
              'status' => 'started' },
            { 'id' => '1c92c1a9-4b5b-466b-92bf-05bbc3bca5e8', 'domain' => 'fo.test',
              'status' => 'started' }]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      assert_changes('Auction.count', 3) do
        instance.call
        example_auction = Auction.find_by(remote_id: 'cdf377a6-8797-40d8-90a1-b7aadfddc8e3')
        assert_equal(Time.now.in_time_zone + 1.minute, example_auction.starts_at)
        assert_equal(Time.now.in_time_zone + 1.minute + 1.day, example_auction.ends_at)
      end
    end
  end

  def test_english_auction_in_new_round_should_appear_with_the_same_values
    travel_back

    auction = Auction.find_by(domain_name: 'english_auction.test')
    auction.update(starts_at: Time.zone.now - 2.day, ends_at: Time.zone.now - 1.day, initial_ends_at: Time.zone.now - 1.day)
    auction.reload

    instance = Registry::AuctionCreator.new

    body = [{ 'id' => '362589b9-dc74-484d-8fef-7282816d5c76', 'domain' => "#{auction.domain_name}", 'status' => 'started', 'platform' => 'manual'}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call

      auctions = Auction.where(domain_name: auction.domain_name)

      assert_equal auctions.count, 2
      assert_equal auctions.first.starting_price, auctions.last.starting_price
      assert_equal auctions.first.platform, auctions.last.platform
      assert_equal auctions.first.min_bids_step, auctions.last.min_bids_step
      assert_equal auctions.first.slipping_end, auctions.last.slipping_end
    end
  end

  def test_incoming_data_should_assign_auction_type
    travel_back

    auction = Auction.find_by(domain_name: 'english_auction.test')
    auction.update(starts_at: Time.zone.now - 2.day, ends_at: Time.zone.now - 1.day, initial_ends_at: Time.zone.now - 1.day)
    auction.reload

    assert_equal auction.platform, 'english'

    instance = Registry::AuctionCreator.new

    body = [{ 'id' => '362589b9-dc74-484d-8fef-7282816d5c76', 'domain' => "#{auction.domain_name}", 'status' => 'started', 'platform' => 'auto'}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call

      auctions = Auction.where(domain_name: auction.domain_name)

      assert_equal auctions.last.platform, 'blind'
    end
  end

  def test_incoming_data_should_assign_blind_if_platform_is_nil
    travel_back

    instance = Registry::AuctionCreator.new

    body = [{ 'id' => '362589b9-dc74-484d-8fef-7282816d5c76', 'domain' => "doople.ee", 'status' => 'started', 'platform' => nil}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call

      auctions = Auction.where(domain_name: 'doople.ee')

      assert_equal auctions.last.platform, 'blind'
    end
  end

  def test_initialize_ends_at_and_starts_at_data_based_on_the_previous_round
    travel_back

    auction = Auction.find_by(domain_name: 'english_auction.test')
    auction.update(starts_at: '2022-07-11 10:24:00', ends_at: '2022-07-14 10:57:21.599999', initial_ends_at: '2022-07-14 10:45:00')
    auction.reload

    assert_equal auction.platform, 'english'

    instance = Registry::AuctionCreator.new

    body = [{ 'id' => '362589b9-dc74-484d-8fef-7282816d5c76', 'domain' => "#{auction.domain_name}", 'status' => 'started', 'platform' => 'manual'}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call

      auctions = Auction.where(domain_name: auction.domain_name)

      as = auctions.first.initial_ends_at.strftime("%H:%M:%S")
      new_ends_at = (Date.current + Rational(3)).in_time_zone + Time.parse(as).seconds_since_midnight.second

      assert_equal auctions.last.ends_at.change(usec: 0), new_ends_at.change(usec: 0)
      assert_equal auctions.last.initial_ends_at.change(usec: 0), new_ends_at.change(usec: 0)
      assert_equal auctions.last.starts_at.change(usec: 0), Time.zone.now.change(usec: 0)
    end
  end
end
