module Captcha
  class Component < ApplicationViewComponent
    attr_reader :show_checkbox_recaptcha, :captcha_required, :action

    def initialize(captcha_required:, show_checkbox_recaptcha:, action:)
      super()

      @show_checkbox_recaptcha = show_checkbox_recaptcha
      @captcha_required = captcha_required
      @action = action
    end
  end
end
