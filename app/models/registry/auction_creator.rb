module Registry
  class AuctionCreator < Base
    def initialize; end

    def request
      @request ||= Net::HTTP::Get.new(
        BASE_URL,
        'Content-Type': 'application/json'
      )
    end

    def call
      perform_request(request)

      body_as_json = JSON.parse(body_as_string, symbolize_names: true)
      body_as_json.each do |item|
        create_auction_from_api(item[:domain], item[:id])
        send_wishlist_notifications(item[:domain], item[:id])
      end
    end

    private

    def auction_duration_in_seconds
      Setting.find_by(code: 'auction_duration').retrieve * 60 * 60
    end

    def auction_starts_at
      setting = Setting.find_by(code: 'auctions_start_at').retrieve
      if setting
        (Date.current + Rational(24 + setting, 24)).in_time_zone
      else
        Time.current + 1.minute
      end
    end

    def auction_ends_at
      setting = Setting.find_by(code: 'auction_duration').retrieve

      if setting == :end_of_day
        (auction_starts_at.to_date + 1).in_time_zone - 1
      else
        Time.at(auction_starts_at.to_i + setting * 60 * 60).in_time_zone
      end
    end

    def create_auction_from_api(domain_name, remote_id)
      Auction.find_or_initialize_by(domain_name: domain_name, remote_id: remote_id) do |auction|
        auction.starts_at = auction_starts_at
        auction.ends_at = auction_ends_at
        auction.save!
      end
    end

    def send_wishlist_notifications(domain_name, remote_id)
      WishlistJob.set(wait: WishlistJob.wait_time)
                 .perform_later(domain_name, remote_id)
    end
  end
end
