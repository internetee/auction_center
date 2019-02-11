class AddLocaleParameterToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.column :locale, :string, null: false, default: 'en'
    end
  end
end
