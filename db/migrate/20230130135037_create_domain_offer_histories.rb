class CreateDomainOfferHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :domain_offer_histories do |t|
      t.references :auction, null: false, foreign_key: true
      t.references :billing_profile, null: false, foreign_key: true
      t.integer :bid_in_cents

      t.timestamps
    end
  end
end
