module Common
  module Form
    module PasswordField
      module Description
        class Component < ApplicationViewComponent
          attr_reader :form, :attribute, :minimum_password_length, :user

          def initialize(form:, attribute:, minimum_password_length:, user:)
            super()

            @form = form
            @attribute = attribute
            @minimum_password_length = minimum_password_length
            @user = user
          end
        end
      end
    end
  end
end