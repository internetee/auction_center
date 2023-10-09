# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'jsbundling-rails'
gem "propshaft"
gem 'cssbundling-rails'
gem 'view_component'
gem 'airbrake'
gem 'amazing_print'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'cancancan'
gem 'chartkick'
gem 'data_migrate'
gem 'delayed_job', '~> 4.1.0'
gem 'delayed_job_active_record'
gem 'devise'
gem 'directo', github: 'internetee/directo', branch: 'master'
gem 'faraday'
gem 'jbuilder', '~> 2.11'
gem 'lograge'
gem 'mimemagic', '~> 0.4.3'
gem 'money'
gem 'okcomputer', '~> 1.18.4'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-tara', github: 'internetee/omniauth-tara'
gem 'pdfkit'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 6.4.2'
gem 'rails', '>= 6.0.3.5'
gem 'rails-i18n'
gem 'recaptcha'
gem 'ruby-openai'
gem 'scenic'
gem 'simpleidn'
gem 'skylight'
gem 'turbo-rails'
gem 'webpush'
gem 'valvat'

gem 'jwt'

group :development, :test do
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'

  # https://github.com/rubocop/rubocop-performance
  gem 'rubocop-performance', require: false
  gem "ruby-lsp"
  gem "rubocop"
  gem "rubocop-packaging"
  gem "rubocop-rspec"
  gem "rubocop-shopify"
  gem "rubocop-thread_safety"
end

group :development do
  gem 'i18n-debug'
  gem 'listen', '>= 3.0.5', '< 3.9'
  gem 'web-console', '>= 3.3.0'
  gem 'htmlbeautifier'
  gem "ruby-lsp-rails"
  gem 'letter_opener', '~> 1.8'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.10', '< 0.18', require: false
  gem 'spy'
  gem 'webmock'
end

# frontend
gem 'hotwire-rails', '~> 0.1.3'
# Use Redis for Action Cable

# gem 'redis', '~> 5.0'
gem 'redis', '~> 5.0'

# For search
gem 'pg_search'

# For pagination
gem 'pagy', '~> 6.0'

# For mock username
gem 'faker'

gem 'noticed', '~> 1.6'
gem "freezolite", require: false