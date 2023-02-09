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

  def test_should_run_new_auction_instance_if_previously_was_no_bids
    travel_back
    legacy_auction = auctions(:valid_with_offers)
    auctions = Auction.where(domain_name: legacy_auction.domain_name)
    assert_equal auctions.count, 1

    instance = Registry::AuctionCreator.new

    body = [{ 'id' => '362589b9-dc74-484d-8fef-7282816d5c76', 'domain' => legacy_auction.domain_name, 'status' => 'started', 'platform' => nil}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call

      auctions = Auction.where(domain_name: legacy_auction.domain_name)

      assert_equal auctions.count, 2
    end
  end

  def test_english_auction_who_first_time_should_be_started_dates_as_nil
    travel_back

    instance = Registry::AuctionCreator.new

    body = [{ 'id' => '362589b9-dc74-484d-8fef-7282816d5c76',
              'domain' => 'englishtea.com',
              'status' => 'started',
              'platform' => 'manual'}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call

      auctions = Auction.where(domain_name: 'englishtea.com')
      assert_equal auctions.count, 1

      auction = auctions.first
      assert_nil auction.starts_at
      assert_nil auction.ends_at
    end
  end

  def test_english_auction_who_comes_next_tour_should_have_specific_started_dates
    travel_back

    english_auction = auctions(:english)
    result = results(:expired_participant)
    result.update(status: 'payment_not_received', auction: english_auction)
    result.reload

    instance = Registry::AuctionCreator.new

    body = [{ 'id' => '362589b9-dc74-484d-8fef-7282816d5c76',
              'domain' => english_auction.domain_name,
              'status' => 'started',
              'platform' => 'manual'}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call

      auctions = Auction.where(domain_name: english_auction.domain_name)
      assert_equal auctions.count, 2

      legacy_auction = auctions.first
      auction = auctions.last

      additional_day = reassign_ends_at(legacy_auction, auction)
      days_difference = ((legacy_auction.initial_ends_at - legacy_auction.starts_at) / 86400).to_i + additional_day

      assert_equal auction.starts_at.to_date, Time.zone.now.to_date
      assert_equal auction.ends_at.to_date, Time.zone.now.to_date + days_difference.days
    end
  end

  def test_auction_should_be_blind_after_release_if_before_results_has_no_bids
    travel_back

    english_auction = auctions(:english)
    result = results(:expired_participant)
    result.update(status: 'no_bids', auction: english_auction)
    result.reload

    instance = Registry::AuctionCreator.new

    body = [{ 'id' => '362589b9-dc74-484d-8fef-7282816d5c76',
              'domain' => english_auction.domain_name,
              'status' => 'started',
              'platform' => 'auto'}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call

      auctions = Auction.where(domain_name: english_auction.domain_name)
      assert_equal auctions.count, 2
      auction = auctions.last

      assert_equal auction.platform, 'blind'
      assert_equal(Date.tomorrow.to_datetime, auction.starts_at)
      assert_equal(Date.tomorrow.to_datetime + 1.day, auction.ends_at)
    end
  end

  def test_next_round_auctions_should_be_comes_with_enabled_deposit_for_previous_participants
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_number_generator")
    .to_return(status: 200, body: @invoice_number.to_json, headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator")
      .to_return(status: 200, body: @invoice_link.to_json, headers: {})

    stub_request(:put, "http://registry:3000/eis_billing/e_invoice_response").
      to_return(status: 200, body: @invoice_number.to_json, headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/e_invoice/e_invoice").
      to_return(status: 200, body: "", headers: {})

    user1 = users(:participant)
    user2 = users(:second_place_participant)
    deposit_value = 50_000
    travel_back

    auction = auctions(:english)
    auction.update(enable_deposit: true, requirement_deposit_in_cents: deposit_value, ends_at: Time.now.utc + 10.minutes)
    auction.reload
    assert auction.offers.empty?
    assert auction.enable_deposit?

    DomainParticipateAuction.create(user_id: user1.id, auction_id: auction.id)
    DomainParticipateAuction.create(user_id: user2.id, auction_id: auction.id)

    user1.reload && user2.reload
    assert auction.allow_to_set_bid?(user1)
    assert auction.allow_to_set_bid?(user2)
    travel_to 3.hours.from_now

    ResultCreationJob.perform_now

    auction.reload
    user1.reload && user2.reload

    instance = Registry::AuctionCreator.new

    body = [{ 'id' => '362589b9-dc74-484d-8fef-7282816d5c76',
              'domain' => auction.domain_name,
              'status' => 'started',
              'platform' => 'manual'}]
    response = Minitest::Mock.new

    response.expect(:code, '200')
    response.expect(:body, body.to_json)

    http = Minitest::Mock.new
    http.expect(:request, nil, [instance.request])

    Net::HTTP.stub(:start, response, http) do
      instance.call

      auctions = Auction.where(domain_name: auction.domain_name)
      assert_equal auctions.count, 2
      auction = auctions.last

      assert_equal auction.platform, 'english'

      auction.reload && user1.reload && user2.reload

      assert auction.enable_deposit?
      refute auction.allow_to_set_bid?(user1)
      refute auction.allow_to_set_bid?(user2)
    end
  end

  def reassign_ends_at(legacy_auction, new_auction)
    t1 = legacy_auction.starts_at
    t2 = new_auction.starts_at
    t1_time = t1.strftime('%H:%M:%S')
    t2_time = t2.strftime('%H:%M:%S')

    t1_time < t2_time ? 1 : 0
  end
end
