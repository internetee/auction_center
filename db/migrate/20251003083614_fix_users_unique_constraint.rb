class FixUsersUniqueConstraint < ActiveRecord::Migration[8.0]
  def change
    # Remove the old unique index that doesn't allow multiple empty identity_code values
    remove_index :users, name: :users_by_identity_code_and_country, if_exists: true

    # Create a new unique index that only applies when identity_code is not empty
    # This allows multiple users with empty identity_code for the same country
    add_index :users,
              [:alpha_two_country_code, :identity_code],
              unique: true,
              where: "alpha_two_country_code = 'EE' AND identity_code IS NOT NULL AND identity_code != ''",
              name: :users_by_identity_code_and_country
  end
end
