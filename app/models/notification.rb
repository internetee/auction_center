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

    # Sanitize params by removing ActiveJob reserved keys
    sanitized_params = sanitize_params(params || {})

    # Return instance with sanitized params from the notification record
    notification_class.new(params: sanitized_params)
  end

  private

  def sanitize_params(params_hash)
    return params_hash unless params_hash.is_a?(Hash)

    sanitized = params_hash.except('_aj_globalid', '_aj_serialized', :_aj_globalid, :_aj_serialized)

    sanitized.transform_values do |value|
      case value
      when Hash
        sanitize_params(value)
      when Array
        value.map { |item| item.is_a?(Hash) ? sanitize_params(item) : item }
      else
        value
      end
    end
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
