if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-json'
  require 'simplecov-lcov'
  
  # Настраиваем lcov для совместимости с CodeClimate
  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = 'coverage/lcov.info'
  end
  
  SimpleCov.command_name 'test'
  SimpleCov.start 'rails' do
    # Форматируем результаты для CodeClimate, включая lcov формат
    SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::JSONFormatter,
      SimpleCov::Formatter::LcovFormatter
    ])
    
    # Убедимся, что файлы сохраняются в правильном месте
    SimpleCov.coverage_dir 'coverage'
    
    # Выводим сообщение о том, что SimpleCov запущен
    puts "SimpleCov started with rails profile and output to #{SimpleCov.coverage_dir}"
  end
  
  # При завершении работы программы проверяем, что файлы созданы
  at_exit do
    puts "SimpleCov finished. Output files:"
    puts `ls -la coverage/ 2>/dev/null || echo "No coverage directory found"`
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
