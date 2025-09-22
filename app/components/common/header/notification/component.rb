module Common
  module Header
    module Notification
      class Component < ApplicationViewComponent
        attr_reader :notifications

        def initialize(notifications:)
          super()

          @notifications = notifications
        end
      end
    end
  end
end
