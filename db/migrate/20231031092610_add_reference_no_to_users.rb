class AddReferenceNoToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :reference_no, :string
  end
end
