if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-json'

  SimpleCov.command_name 'test'
  
  SimpleCov.start 'rails' do
    SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::JSONFormatter
    ])
    
    SimpleCov.coverage_dir 'coverage'
  end
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'
require 'capybara/rails'
require 'capybara/minitest'
require 'webmock/minitest'
require 'spy/integration'
require 'support/component_helpers'

require 'rake'
Rake::Task.clear
Rails.application.load_tasks

class ActiveSupport::TestCase
  include ComponentHelpers
  self.use_transactional_tests = true
  

  WebMock.allow_net_connect!
  fixtures :all
  
  parallelize(workers: 4) unless ENV['COVERAGE']

  def clear_email_deliveries
    ActionMailer::Base.deliveries.clear
  end
end
