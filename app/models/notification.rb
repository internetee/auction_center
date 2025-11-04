class Notification < ApplicationRecord
  include Noticed::Deliverable

  self.inheritance_column = :_type_disabled

  belongs_to :recipient, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }

  def mark_as_read!
    update!(read_at: Time.current)
  end

  def mark_as_unread!
    update!(read_at: nil)
  end

  def read?
    read_at.present?
  end

  def unread?
    read_at.nil?
  end

  # Noticed 2.x compatibility: return the notification class instance
  def to_notification
    return self unless type.present?

    # Get the notification class (e.g., "AuctionWinnerNotification")
    notification_class = type.safe_constantize
    return self unless notification_class

    # Return instance with params from the notification record
    notification_class.new(params: params || {})
  end

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
