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

  def assert_appears_before(earlier_element, later_element)
    assert(page.text.index(earlier_element) < page.text.index(later_element))
  end
end
