# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'airbrake'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'cancancan'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'devise'
gem 'jbuilder', '~> 2.5'
gem 'kaminari'
gem 'money'
gem 'okcomputer'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-tara', github: 'internetee/omniauth-tara'
gem 'pdfkit'
gem 'pg', '~> 1.1'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.1'
gem 'rails-i18n'
gem 'recaptcha'
gem 'simpleidn'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'
gem 'wkhtmltopdf-binary'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'simplecov', require: false
  gem 'webdrivers'
end
