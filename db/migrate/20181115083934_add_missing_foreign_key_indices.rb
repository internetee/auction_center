class AddMissingForeignKeyIndices < ActiveRecord::Migration[5.2]
  def change
    add_index :offers, :user_id
    add_index :offers, :auction_id
  end
end
