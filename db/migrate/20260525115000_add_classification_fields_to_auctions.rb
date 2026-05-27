class AddClassificationFieldsToAuctions < ActiveRecord::Migration[7.0]
  def change
    add_column :auctions, :classification_tags, :string, array: true, default: [], null: false
    add_column :auctions, :primary_category, :string
    add_column :auctions, :classification_source, :string
    add_column :auctions, :classification_model, :string
    add_column :auctions, :classified_at, :datetime

    add_index :auctions, :classification_tags, using: :gin
    add_index :auctions, :primary_category
  end
end
