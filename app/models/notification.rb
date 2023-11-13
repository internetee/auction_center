class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  # after_create_commit :broadcast_to_bell
  # after_create_commit :broadcast_to_recipient

  def self.notify
    subscriptions = WebpushSubscription.all

    message = {
      title: 'Заголовок уведомления',
      body: 'Текст уведомления',
      icon: 'https://example.com/icon.png'
    }

    subscriptions.each do |subscription|
      Webpush.payload_send(
        message: JSON.generate(message),
        endpoint: subscription.endpoint,
        p256dh: subscription.p256dh,
        auth: subscription.auth,
        ttl: 60,
        vapid: {
          subject: 'mailto:example@example.com',
          public_key: Rails.configuration.customization[:vapid_public],
          private_key: Rails.configuration.customization[:vapid_private]
        }
      )
    end
  end

  # def broadcast_to_recipient
  #   broadcast_append_later_to(
  #     recipient,
  #     :notifications,
  #     target: 'notifications-list',
  #     partial: 'notifications/notification',
  #     locals: {
  #       notification: self
  #     }
  #   )
  # end

  # def broadcast_to_bell
  #   broadcast_update_later_to(
  #     recipient,
  #     :notifications,
  #     target: 'bell-broadcast',
  #     partial: 'notifications/bell',
  #     locals: {
  #       any_unread: true
  #     }
  #   )
  # end
end
