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
      end
    end

    private

    def auction_duration_in_seconds
      Setting.auction_duration * 60 * 60
    end

    def auction_starts_at
      setting = Setting.auctions_start_at
      if setting
        (Date.current + Rational(24 + setting, 24)).in_time_zone
      else
        Time.current + 1.minute
      end
    end

    def create_auction_from_api(domain_name, remote_id)
      ends_at = Time.at(auction_starts_at.to_i + auction_duration_in_seconds).in_time_zone

      Auction.find_or_initialize_by(domain_name: domain_name, remote_id: remote_id) do |auction|
        auction.starts_at = auction_starts_at
        auction.ends_at = ends_at
        auction.save!
      end
    end
  end
end
