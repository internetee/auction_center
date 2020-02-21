class CountAuctionTurns < ActiveRecord::Migration[6.0]
  def up
    Auction.transaction do
      Auction.all.find_each do |auction|
        auction.find_auction_turns
      end
    end
    puts 'All auction turns are counted'
  end

  def down
  end
end
