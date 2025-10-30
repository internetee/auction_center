namespace :auction do
  namespace :test_data do
    desc 'Generate test users, auctions, and historical bids for metrics testing'
    task generate: :environment do
      puts '🚀 Starting test data generation...'

      # Configuration
      users_count = 30
      auctions_count = 40
      days_back = 30
      min_bids_per_auction = 3
      max_bids_per_auction = 15

      # Check if we're in development
      unless Rails.env.development?
        puts '❌ This task can only be run in development environment'
        exit 1
      end

      # Step 1: Generate Users
      puts "\n📝 Creating #{users_count} test users..."
      users = []

      users_count.times do |i|
        email = "test_bidder_#{i + 1}@example.com"

        # Skip if user already exists
        if User.exists?(email: email)
          users << User.find_by(email: email)
          next
        end

        user = User.create!(
          email: email,
          password: 'Password123!',
          password_confirmation: 'Password123!',
          given_names: Faker::Name.first_name,
          surname: Faker::Name.last_name,
          alpha_two_country_code: 'EE',
          mobile_phone: "+372#{rand(50000000..59999999)}",
          roles: ['participant'],
          terms_and_conditions_accepted_at: Time.zone.now,
          confirmed_at: Time.zone.now,
          mobile_phone_confirmed_at: Time.zone.now
        )

        users << user
        print '.'
      end

      puts "\n✅ Created #{users.count} users"

      # Step 2: Create Billing Profiles for each user
      puts "\n📝 Creating billing profiles..."

      users.each do |user|
        next if user.billing_profiles.exists?

        BillingProfile.create!(
          user: user,
          name: user.display_name,
          alpha_two_country_code: 'EE',
          street: Faker::Address.street_address,
          city: Faker::Address.city,
          postal_code: rand(10000..99999).to_s
        )
        print '.'
      end

      puts "\n✅ Created #{users.count} billing profiles"

      # Step 3: Generate Blind Auctions
      puts "\n📝 Creating #{auctions_count} blind auctions..."
      auctions = []

      auctions_count.times do |i|
        # Generate auction dates spread over last 30 days
        days_ago = rand(0..days_back)
        starts_at = days_ago.days.ago.beginning_of_day + rand(8..18).hours
        ends_at = starts_at + rand(3..7).days

        domain_name = "test-domain-#{SecureRandom.hex(4)}.ee"

        auction = Auction.create!(
          domain_name: domain_name,
          platform: :blind, # Blind auction (platform = 0)
          starts_at: starts_at,
          ends_at: ends_at,
          starting_price: rand(100..1000).to_d,
          skip_validation: true # Skip overlap validation for test data
        )

        auctions << auction
        print '.'
      end

      puts "\n✅ Created #{auctions.count} auctions"

      # Step 4: Generate Historical Bids
      puts "\n📝 Generating historical bids..."
      total_bids = 0

      auctions.each do |auction|
        # Random number of bidders for this auction
        bidders_count = rand(min_bids_per_auction..max_bids_per_auction)

        # Select random unique users for this auction
        auction_bidders = users.sample(bidders_count)

        auction_bidders.each do |bidder|
          billing_profile = bidder.billing_profiles.first

          # Generate bid price
          bid_price = auction.starting_price + rand(50..500)

          # Generate bid timestamp within auction period
          bid_time = auction.starts_at + rand(0..(auction.ends_at - auction.starts_at).to_i).seconds

          # Create offer with historical timestamp
          offer = Offer.new(
            auction: auction,
            user: bidder,
            billing_profile: billing_profile,
            cents: (bid_price * 100).to_i,
            skip_validation: true # Skip validation for test data
          )

          # Manually set timestamps to historical dates
          offer.created_at = bid_time
          offer.updated_at = bid_time

          # Save without callbacks to avoid triggering real-time metrics
          offer.save!(validate: false)

          # Now manually trigger the metric tracking with historical date
          begin
            Metrics::UniqueUserBidderTracker.track(bidder.id, date: bid_time.to_date)
          rescue => e
            puts "\n⚠️  Warning: Failed to track metric for user #{bidder.id}: #{e.message}"
          end

          total_bids += 1
          print '.'
        end
      end

      puts "\n✅ Created #{total_bids} historical bids"

      # Step 5: Summary Statistics
      puts "\n" + "="*60
      puts "📊 Test Data Generation Summary"
      puts "="*60
      puts "Users created: #{users.count}"
      puts "Auctions created: #{auctions.count}"
      puts "Total bids created: #{total_bids}"
      puts "Date range: #{days_back} days ago to today"
      puts ""

      # Unique bidders per day statistics
      puts "📈 Unique Bidders by Day:"
      (0..days_back).each do |days_ago|
        date = days_ago.days.ago.to_date
        count = begin
          Metrics::UniqueUserBidderTracker.count(date: date)
        rescue
          0
        end

        if count > 0
          puts "  #{date}: #{count} unique bidders"
        end
      end

      puts "\n✅ Test data generation complete!"
      puts "\n💡 View metrics at: http://localhost:3000/metrics"
      puts "💡 Check Prometheus/Grafana for auction_unique_bidders_daily metric"
    end

    desc 'Clean up all test auction data'
    task clean: :environment do
      puts '🧹 Cleaning up test data...'

      unless Rails.env.development?
        puts '❌ This task can only be run in development environment'
        exit 1
      end

      # Delete test users and their associated data
      test_users = User.where('email LIKE ?', 'test_bidder_%@example.com')
      puts "Deleting #{test_users.count} test users and their data..."
      test_users.destroy_all

      # Delete test auctions
      test_auctions = Auction.where('domain_name LIKE ?', 'test-domain-%')
      puts "Deleting #{test_auctions.count} test auctions..."
      test_auctions.destroy_all

      # Clear Redis metrics
      puts "Clearing Redis metrics..."
      begin
        redis = Redis.current
        keys = redis.keys("auction:unique_bidders:*")
        redis.del(*keys) if keys.any?
        puts "Deleted #{keys.count} Redis keys"
      rescue => e
        puts "⚠️  Warning: Could not clear Redis: #{e.message}"
      end

      puts "✅ Cleanup complete!"
    end
  end
end
