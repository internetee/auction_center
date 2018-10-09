class AddSettingsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.string :code, null: false
      t.text :description, null: false
      t.text :value, null: false

      t.timestamps()
    end

    add_index :settings, :code, unique: true
  end
end
