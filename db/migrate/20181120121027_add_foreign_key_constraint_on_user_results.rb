class AddForeignKeyConstraintOnUserResults < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :results, :users
  end
end
