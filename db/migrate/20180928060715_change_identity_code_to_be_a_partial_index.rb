class ChangeIdentityCodeToBeAPartialIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, column: [:alpha_two_country_code, :identity_code]

    add_index :users,
      [:alpha_two_country_code, :identity_code],
      name: "users_by_identity_code_and_country",
      unique: true,
      where: "alpha_two_country_code = 'EE'"
  end
end
