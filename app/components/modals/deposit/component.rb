module Modals
  module Deposit
    class Component < ApplicationViewComponent
      attr_reader :auction, :current_user, :captcha_required

      def initialize(auction:, current_user:, captcha_required:)
        super

        @auction = auction
        @current_user = current_user
        @captcha_required = captcha_required
      end
    end
  end
end
