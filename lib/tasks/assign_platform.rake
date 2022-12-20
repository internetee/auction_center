namespace :auction do
  desc 'Assign bling type to auctions what have status of nil'
  task assign_platform: :environment do
    Auction.where(platform: nil).in_batches do |batch_auctions|
      batch_auctions.update_all(platform: 'blind')
    end
    # auctions.update_all(platform: 'blind')
  end
end
