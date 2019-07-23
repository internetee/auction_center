require 'test_helper'

class AuctionCreationJobTest < ActiveJob::TestCase
  def setup
    super
  end

  def teardown
    super
  end

  def test_perform_now
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
    http.expect(:request, nil, [Net::HTTP::Get])

    Net::HTTP.stub(:start, response, http) do
      assert_changes('Auction.count', 3) do
        AuctionCreationJob.perform_now
      end
    end
  end

  def test_needs_to_run_depends_on_a_configuration_variable
    AuctionCreationJob.stub(:registry_integration_enabled?, true) do
      assert(AuctionCreationJob.needs_to_run?)
    end

    assert_not(AuctionCreationJob.needs_to_run?)
  end
end
