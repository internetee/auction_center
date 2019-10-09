class AddAuctionNewsletterToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :auction_newsletter, :boolean, default: false
  end
end
