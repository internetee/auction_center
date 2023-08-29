module RecaptchaValidatable
  extend ActiveSupport::Concern

  included do
    before_action :set_captcha_required
    before_action :check_recaptcha, only: %i[create update]
  end

  module ClassMethods
    attr_reader :action

    private

    def recaptcha_action(action)
      @action = action
    end
  end

  def set_captcha_required
    return if Rails.env.development?

    @captcha_required = current_user.requires_captcha?
    @recaptcha2_site_key = AuctionCenter::Application.config.customization.dig(:recaptcha, :recaptcha2_site_key)
    @recaptcha3_site_key = AuctionCenter::Application.config.customization.dig(:recaptcha, :recaptcha3_site_key)
  end

  def check_recaptcha
    @success = verify_recaptcha(action: self.class.action,
                                minimum_score: min_score,
                                secret_key: recaptcha3_secret)
    return if @success

    @checkbox_success = verify_recaptcha model: @offer,
                                         secret_key: recaptcha2_secret
  end

  def recaptcha_valid
    return true unless @captcha_required

    @success || @checkbox_success
  end

  def min_score
    AuctionCenter::Application.config.customization.dig(:recaptcha, :min_score)
  end

  def recaptcha3_secret
    AuctionCenter::Application.config.customization.dig(:recaptcha, :recaptcha3_secret_key)
  end

  def recaptcha2_secret
    AuctionCenter::Application.config.customization.dig(:recaptcha, :recaptcha2_secret_key)
  end
end
