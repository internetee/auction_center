class AddRoleFieldToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :roles, :string, array: true
    change_column_default :users, :roles, from: nil, to: [User::PARTICIPANT_ROLE]
  end
end
