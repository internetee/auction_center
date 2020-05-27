class FixMultiplePhoneConfirmations < ActiveRecord::Migration[6.0]
  def up
    grouped_users = User.with_confirmed_phone.order(created_at: :desc).group_by(&:mobile_phone)
    grouped_users.each do |_key, value|
      next if value.count == 1

      value.each_with_index do |value, index|
        next if index.zero?

        value.update_column(:mobile_phone_confirmed_at, nil)
      end
    end
  end

  def down; end
end
