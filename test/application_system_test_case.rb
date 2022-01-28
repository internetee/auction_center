require 'test_helper'
require 'support/semantic_ui_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers

  include SemanticUiHelper

  # def setup
  #   super
  #   DatabaseCleaner.start
  # end

  # teardown do
  #   super

  #   WebMock.reset!
  #   Capybara.reset_sessions!
  #   Capybara.use_default_driver
  #   DatabaseCleaner.clean
  # end

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
end
