if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.command_name 'test'
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def clear_email_deliveries
    ActionMailer::Base.deliveries.clear
  end

  # Required by semantic-ui javascript
  def select_from_dropdown(item_text, options)
    dropdown = find_field(options[:from], visible: false).first(:xpath,".//..")
    dropdown.click
    dropdown.find(".menu .item", :text => item_text).click
  end

  def uncheck_checkbox(item_text)
    uncheck(item_text, visible: false)
  end

  def check_checkbox(item_text)
    check(item_text, visible: false)
  end
end
