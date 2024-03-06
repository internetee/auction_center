module Modals
  module NoResetPasswordLink
    class Component < ApplicationViewComponent
      include Devise::Controllers::Helpers

      attr_reader :resource, :resource_name

      def initialize(resource:, resource_name:)
        super

        @resource = resource
        @resource_name = resource_name
      end
    end
  end
end
