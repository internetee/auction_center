class FixUsersUniqueConstraint < ActiveRecord::Migration[8.0]
  def change
    remove_index :users, name: :users_by_identity_code_and_country, if_exists: true

    add_index :users,
              %i[alpha_two_country_code identity_code],
              unique: true,
              where: "alpha_two_country_code = 'EE' AND identity_code IS NOT NULL AND identity_code != ''",
              name: :users_by_identity_code_and_country
  end
end
