class CreateInterestCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :interest_categories do |t|
      t.uuid :uuid, default: 'gen_random_uuid()', null: false
      t.string :code, null: false
      t.string :name_en, null: false
      t.string :name_et, null: false
      t.integer :position, default: 0, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :interest_categories, :code, unique: true
    add_index :interest_categories, :uuid, unique: true
    add_index :interest_categories, %i[active position]
  end
end
