class CreateWebpushSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :webpush_subscriptions do |t|
      t.string :endpoint
      t.string :p256dh
      t.string :auth
      t.references :user

      t.timestamps
    end
  end
end
