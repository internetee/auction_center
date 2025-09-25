# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'airbrake'
gem 'amazing_print'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'cancancan'
gem 'chartkick'
gem 'cssbundling-rails', '~> 1.4.3'
gem 'csv'
gem 'data_migrate', '~> 11.3.0'
gem 'delayed_job', '~> 4.1.0'
gem 'delayed_job_active_record'
gem 'devise', '~> 4.9.3'
gem 'directo', github: 'internetee/directo', branch: 'master'
gem 'faker'
gem 'faraday'
gem 'freezolite', require: false
gem 'hotwire-rails', '~> 0.1.3'
gem 'jbuilder', '~> 2.11'
gem 'jsbundling-rails'
gem 'jwt'
gem 'lograge'
gem 'mimemagic', '~> 0.4.3'
gem 'money'
gem 'mutex_m'
gem 'net-imap', '>= 0.5.7'
gem 'nokogiri', '>= 1.18.9'
gem 'noticed', '~> 1.6'
gem 'okcomputer', '~> 1.19.0'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-tara', github: 'internetee/omniauth-tara'
gem 'pagy', '~> 9.0'
gem 'pdfkit'
gem 'pg', '>= 0.18', '< 2.0'
gem 'pg_search'
gem 'propshaft'
gem 'puma', '~> 6.6.0'
gem 'rails', '~> 8.0.2'
gem 'rack', '~> 2.2.18'
gem 'rails-i18n'
gem 'recaptcha'
gem 'redis', '~> 5.0'
gem 'ruby-openai', '~> 7.3'
gem 'scenic'
gem 'simpleidn'
gem 'turbo-rails'
gem 'valvat'
gem 'view_component'
gem 'webpush'

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
end

group :development do
  gem 'attractor'
  gem 'attractor-javascript'
  gem 'attractor-ruby'
  gem 'htmlbeautifier'
  gem 'i18n-debug'
  gem 'letter_opener', '~> 1.8'
  gem 'letter_opener_web', '~> 3.0'
  gem 'listen', '>= 3.0.5', '< 3.10'
  gem 'ruby-lsp-rails'
  gem 'web-console', '>= 3.3.0'
  gem 'foreman'

  # https://github.com/rubocop/rubocop-performance
  gem 'rubocop'
  gem 'rubocop-packaging'
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec'
  gem 'rubocop-shopify'
  gem 'ruby-lsp'
  # gem "rubocop-thread_safety"
  gem "hotwire-spark"
end

group :test do
  gem 'capybara', '>= 3.4.0'
  # gem 'cuprite'
  # gem 'selenium-webdriver'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'simplecov-json', require: false
  gem 'spy'
  gem 'webmock'
end
