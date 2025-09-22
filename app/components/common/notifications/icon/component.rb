module Common
  module Notifications
    module Icon
      class Component < ViewComponent::Base
        attr_reader :notification_type, :readed

        def initialize(notification:, readed:)
          @notification_type = notification.type
          @readed = readed

          super()
        end
      end
    end
  end
end
