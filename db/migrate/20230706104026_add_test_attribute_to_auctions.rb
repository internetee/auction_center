class AddTestAttributeToAuctions < ActiveRecord::Migration[7.0]
  def change
    add_column :auctions, :test_attr, :string
  end
end
