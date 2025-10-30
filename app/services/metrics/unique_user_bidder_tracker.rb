module Metrics
  class UniqueUserBidderTracker
    REDIS_KEY_PREFIX = "auction:unique_bidders"
    TTL_SECONDS = 86400 # 24 hours

    def self.track(user_id, date: Date.current)
      redis = redis_connection
      key = daily_key(date)

      # Add to Redis set (O(1), idempotent)
      was_new_bidder = redis.sadd(key, user_id)

      # Set expiration on key creation
      redis.expire(key, TTL_SECONDS) unless redis.ttl(key) > 0

      # Update Yabeda gauge
      current_count = redis.scard(key)
      Yabeda.auction.unique_bidders_daily.set({date: date.to_s}, current_count)

      Rails.logger.info("Unique bidder tracked: user_id=#{user_id}, date=#{date}, count=#{current_count}, new=#{was_new_bidder}")

      was_new_bidder
    end

    def self.count(date: Date.current)
      redis_connection.scard(daily_key(date))
    end

    def self.redis_connection
      @redis ||= begin
        url = ENV.fetch('REDIS_URL') { AuctionCenter::Application.config.customization[:cable_redis_url] }
        Redis.new(url: url, timeout: 1, reconnect_attempts: 1)
      end
    end

    def self.daily_key(date)
      "#{REDIS_KEY_PREFIX}:#{date.strftime('%Y%m%d')}"
    end

    private_class_method :daily_key, :redis_connection
  end
end
