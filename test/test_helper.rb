if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-json'
  SimpleCov.command_name 'test'
  SimpleCov.start 'rails' do
    # Форматируем результаты для CodeClimate
    SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::JSONFormatter
    ])
    
    # Убедимся, что файлы сохраняются в правильном месте
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

  WebMock.allow_net_connect!
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Отключаем параллельный запуск тестов при измерении покрытия кода,
  # так как SimpleCov не может правильно объединить результаты из разных процессов
  unless ENV['COVERAGE']
    parallelize(workers: 4)
  end

  # Add more helper methods to be used by all tests here...
  def clear_email_deliveries
    ActionMailer::Base.deliveries.clear
  end
end
