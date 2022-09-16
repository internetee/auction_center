class AddUniqueNumberToInoivces < ActiveRecord::Migration[6.1]
  def change
    add_index :invoices, :number, unique: true
  end
end
