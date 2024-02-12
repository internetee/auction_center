class AddSmsSendTimestampToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :mobile_phone_confirmed_sms_send_at, :datetime
  end
end
