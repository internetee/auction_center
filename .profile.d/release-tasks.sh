#!/bin/sh

RAILS_ENV=production bundle exec rake assets:precompile
cp config/customization.yml.sample config/customization.yml
