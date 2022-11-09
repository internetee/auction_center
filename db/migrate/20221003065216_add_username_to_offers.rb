class AddUsernameToOffers < ActiveRecord::Migration[6.1]
  def change
    add_column :offers, :username, :string, null: true
  end
end
