class AddEnableColumnToAutobiders < ActiveRecord::Migration[7.0]
  def change
    add_column :autobiders, :enable, :boolean, default: false
  end
end
