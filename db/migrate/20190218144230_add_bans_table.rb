class AddBansTable < ActiveRecord::Migration[5.2]
  def change
    create_table :bans do |t|
      t.integer :user_id, null: false
      t.datetime :valid_until, null: true
      t.string :domain_name, null: true

      t.timestamps
    end

    add_foreign_key :bans, :users
    add_index :bans, :user_id
    add_index :bans, :domain_name
  end
end
