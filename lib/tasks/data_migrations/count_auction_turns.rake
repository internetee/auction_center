namespace :data_migrations do
  desc 'Populate auctions with auction turns count'
  task count_auction_turns: :environment do
    Auction.transaction do
      Auction.all.find_each do |auction|
        puts "Processing auction #{auction.id}"
        auction._run_create_callbacks
      end
    end
    puts 'All auctions processed.'
  end
end
