require 'test_helper'
require 'support/cuprite_helpers'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers
  include CupriteHelpers

  # driven_by :headless_chrome
  driven_by :rack_test

  # Usually, especially when using Selenium, developers tend to increase the max wait time.
  # With Cuprite, there is no need for that.
  # We use a Capybara default value here explicitly.
  Capybara.default_max_wait_time = 10

  # Normalize whitespaces when using `has_text?` and similar matchers,
  # i.e., ignore newlines, trailing spaces, etc.
  # That makes tests less dependent on slightly UI changes.
  Capybara.default_normalize_ws = true

  # Where to store system tests artifacts (e.g. screenshots, downloaded files, etc.).
  # It could be useful to be able to configure this path from the outside (e.g., on CI).
  Capybara.save_path = ENV.fetch("CAPYBARA_ARTIFACTS", "./tmp/capybara")

  Capybara.singleton_class.prepend(Module.new do
    attr_accessor :last_used_session

    def using_session(name, &block)
      self.last_used_session = name
      super
    ensure
      self.last_used_session = nil
    end
  end)

  Capybara.register_driver(:better_cuprite) do |app|
    Capybara::Cuprite::Driver.new(
      app,
      **{
        window_size: [1200, 800],
        # See additional options for Dockerized environment in the respective section of this article
        browser_options: {},
        # Increase Chrome startup wait time (required for stable CI builds)
        process_timeout: 10,
        # Enable debugging capabilities
        inspector: true,
        # Allow running Chrome in a headful mode by setting HEADLESS env
        # var to a falsey value
        headless: !ENV["HEADLESS"].in?(%w[n 0 no false])
      }
    )
  end
  
  # Configure Capybara to use :better_cuprite driver by default
  Capybara.default_driver = Capybara.javascript_driver = :better_cuprite
  
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
