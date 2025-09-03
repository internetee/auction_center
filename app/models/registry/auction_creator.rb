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
        unless valid_domain_name?(item[:domain])
          Rails.logger.info "Skipping invalid domain name: #{item[:domain]}"
          next
        end

        duplicate = Auction.where(domain_name: item[:domain]).last
        next if duplicate&.in_progress?

        create_auction_from_api(item[:domain], item[:id], item[:platform])
        send_wishlist_notifications(item[:domain], item[:id])
      end
    end

    private

    def valid_domain_name?(domain_name)
      return false if domain_name.nil? || domain_name.empty?

      return true if domain_name.to_s.downcase.end_with?('.test')

      name_part = domain_name.to_s.downcase.split('.').first
      return false if name_part.nil? || name_part.empty?
      
      return false if name_part.length < 1 || name_part.length > 63
      return false if name_part.start_with?('-') || name_part.end_with?('-')
      return false if name_part.length >= 4 && name_part[2] == '-' && name_part[3] == '-'

      allowed_pattern = /\A[a-z0-9äöüõšžÄÖÜÕŠŽ\-]+\z/
      return false unless name_part.match?(allowed_pattern)

      return false if name_part.include?('_')

      true
    end

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

    def assign_platform(platform)
      return :blind if platform.nil? || platform == 'auto'

      :english
    end

    def create_auction_from_api(domain_name, remote_id, platform)
      auction_type = assign_platform(platform)

      Auction.find_or_initialize_by(domain_name: domain_name, remote_id: remote_id) do |auction|
        auction.platform = auction_type
        auction.skip_broadcast = true

        if auction.english?
          put_same_values_as_before_for_new_round(auction)
        else
          put_initialize_data_for_blind_auction(auction)
        end
      end

      destroy_autobider(domain_name)
    end

    def put_initialize_data_for_blind_auction(auction)
      auction.starts_at = auction_starts_at
      auction.ends_at = auction_ends_at
      auction.save!
    end

    def put_same_values_as_before_for_new_round(auction)
      auctions = Auction.where(domain_name: auction.domain_name).order(created_at: :asc)

      if auctions.empty?
        auction.skip_validation = true
        auction.starts_at = nil
        auction.ends_at = nil
      else
        legacy_auction = auctions.first
        ends_at_value = legacy_auction.initial_ends_at.presence || legacy_auction.ends_at

        legacy_time_difference = (ends_at_value - legacy_auction.starts_at).to_i.abs
        legacy_difference_in_day = legacy_time_difference / 86_400
        legacy_time = ends_at_value.strftime('%H:%M:%S')
        t = Time.parse(legacy_time).seconds_since_midnight.seconds
        new_ends_at = Time.zone.now.beginning_of_day + legacy_difference_in_day.day + t

        auction.starting_price = legacy_auction.starting_price
        auction.min_bids_step = legacy_auction.starting_price
        auction.slipping_end = legacy_auction.slipping_end
        auction.enable_deposit = legacy_auction.enable_deposit
        auction.requirement_deposit_in_cents = legacy_auction.requirement_deposit_in_cents

        auction.starts_at = Time.zone.now + 1.minute
        additional_day = reassign_ends_at(legacy_auction, auction)
        auction.ends_at = new_ends_at.to_s
        auction.ends_at = auction.ends_at + additional_day.day
        auction.initial_ends_at = auction.ends_at
      end

      auction.save!
    end

    def reassign_ends_at(legacy_auction, new_auction)
      t1 = legacy_auction.starts_at
      t2 = new_auction.starts_at
      t1_time = t1.strftime('%H:%M:%S')
      t2_time = t2.strftime('%H:%M:%S')

      t1_time < t2_time ? 1 : 0
    end

    def indicate_correct_platform_and_assign_it(domain_name)
      auctions = Auction.where(domain_name: domain_name)
      return if auctions.empty?

      platform = auctions.order(created_at: :asc).first.platform
      auction = Auction.where(domain_name: domain_name).order(created_at: :asc).last
      auction.platform = platform.nil? ? :blind : platform.to_sym
      auction.skip_broadcast = true
      auction.skip_validation = true
      auction.save
    end

    def send_wishlist_notifications(domain_name, remote_id)
      WishlistJob.set(wait: 1.minute).perform_later(domain_name, remote_id)
    end

    def destroy_autobider(domain_name)
      autobider = Autobider.where(domain_name: domain_name)
      autobider&.destroy_all
    end
  end
end
