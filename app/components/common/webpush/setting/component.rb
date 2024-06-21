module Common
  module Webpush
    module Setting
      class Component < ApplicationViewComponent
        def data_data
          {
            controller: 'push-notification',
            # profile_webpush_target: 'checkbox',
            push_notification_vapid_public_value: Rails.configuration.customization[:vapid_public],
            action: 'change->push-notification#setupPushNotifications'
          }
        end
      end
    end
  end
end
