require 'test_helper'

class AuctionCreatorWishlistJobTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    travel_to Time.parse('2010-07-05 10:30 +0000')

    @user = users(:participant)
    @wishlist_item = WishlistItem.create!(domain_name: 'shop.test', user: @user)
  end

  def teardown
    super

    clear_email_deliveries
    travel_back
  end

  def test_schedules_wishlist_job
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
        assert_enqueued_with(job: WishlistJob, args: ['shop.test', 'cdf377a6-8797-40d8-90a1-b7aadfddc8e3']) do
          instance.call
        end
      end
    end
  end
end
