class AddIndicesForUserOmniauth < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :users, [:provider, :uid], algorithm: :concurrently,
      unique: true
  end
end
