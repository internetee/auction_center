class DeliveryMethods::Webpush < Noticed::DeliveryMethods::Base
  def deliver
    return unless recipient.webpush_subscription.present?

    Webpush.payload_send(
      message: JSON.generate(format),
      endpoint: recipient.webpush_subscription.endpoint,
      p256dh: recipient.webpush_subscription.p256dh,
      auth: recipient.webpush_subscription.auth,
      ttl: 60,
      vapid: {
        subject: 'mailto:example@example.com',
        public_key: Rails.configuration.customization[:vapid_public],
        private_key: Rails.configuration.customization[:vapid_private]
        }
      )
  end

  private

  def format
    notification.send(options[:format])
  end
end
