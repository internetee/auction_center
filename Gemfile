# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'airbrake'
gem 'amazing_print'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'cancancan'
gem 'chartkick'
gem 'data_migrate'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'devise'
gem 'directo', github: 'internetee/directo', branch: 'master'
gem 'jbuilder', '~> 2.11'
gem 'kaminari'
gem 'mimemagic', '~> 0.4.3'
gem 'money'
gem 'okcomputer', '~> 1.18.4'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-tara', github: 'internetee/omniauth-tara'
gem 'pdfkit'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.6.4'
gem 'rails', '>= 6.0.3.5'
gem 'rails-i18n'
gem 'rails_semantic_logger'
gem 'recaptcha'
gem 'scenic'
gem 'simpleidn'
gem 'skylight'
gem 'sprockets', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 6.0.0.beta.6'

group :development, :test do
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.8'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'simplecov', '~> 0.10', '< 0.18', require: false
  gem 'webdrivers'
  gem 'webmock'
end
