require 'test_helper'
require 'support/semantic_ui_helper'
require 'selenium/webdriver'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers

  include SemanticUiHelper

  Capybara.register_driver(:headless_chrome) do |app|
    options = ::Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--window-size=1400,1400')
    options.add_argument('--disable-dev-shm-usage')

    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  driven_by :headless_chrome
  Capybara.server = :puma, { Silent: true }

  private

  def extract_primary_link_from_last_mail
    mail = ActionMailer::Base.deliveries.last
    mail_html = Nokogiri::HTML(mail.html_part.body.decoded)

    primary_link = mail_html.css('a.button').attr('href').value
    primary_link = URI(primary_link)
    "#{primary_link.path}?#{primary_link.query}"
  end
end
