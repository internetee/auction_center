module Pages
  module Auction
    module NotificationSubscribe
      class Component < ApplicationViewComponent
        attr_reader :current_user

        def initialize(current_user:)
          super

          @current_user = current_user
        end
      end
    end
  end
end