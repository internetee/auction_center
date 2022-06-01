class CreateAutobiders < ActiveRecord::Migration[6.1]
  def change
    create_table :autobiders do |t|
      t.references :user, null: false
      t.string :domain_name, null: false
      t.integer :cents, null: false, default: 0
      t.uuid :uuid, default: 'gen_random_uuid()'

      t.timestamps
    end

    add_foreign_key :autobiders, :users
    add_index :autobiders, :domain_name
  end
end
