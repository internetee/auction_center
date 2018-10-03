class AddBillingProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :billing_profiles do |t|
      t.integer :user_id,      null: false
      t.string  :name,         null: true
      t.string  :vat_code,     null: true
      t.boolean :legal_entity, default: false

      t.string  :street,       null: false
      t.string  :city,         null: false
      t.string  :state,        null: true
      t.string  :postal_code,  null: false
      t.string  :country,      null: false

      t.timestamps             null: false
    end

    add_index :billing_profiles, :user_id
    add_index :billing_profiles, :vat_code, unique: true
  end
end
