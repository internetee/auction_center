class ApplicationViewComponent < ViewComponent::Base
  include ApplicationHelper
  # include HeroiconHelper
  include Turbo::FramesHelper
  include Pagy::Frontend
  include Devise::Controllers::Helpers

  class << self
    def component_name
      @component_name ||= name.sub(/::Component$/, '').underscore
    end
  end

  def recaptcha2_site_key
    AuctionCenter::Application.config.customization.dig(:recaptcha, :recaptcha2_site_key)
  end

  def recaptcha3_site_key
    AuctionCenter::Application.config.customization.dig(:recaptcha, :recaptcha3_site_key)
  end

  def component(name, ...)
    return super unless name.starts_with?('.')

    full_name = self.class.component_name + name.sub('.', '/')

    super(full_name, ...)
  end

  def company_name
    @company_name ||= 'Domain Auction Center'
  end

  def main_app
    Rails.application.class.routes.url_helpers
  end

  def price_format(price)
    separator = I18n.locale == :en ? '.' : ','

    "#{number_to_currency(price, unit: '', separator:, delimiter: '', precision: 2)} €"
  end
end
