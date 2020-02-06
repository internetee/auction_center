#!/bin/sh

cp config/customization.yml.sample config/customization.yml
bundle exec rake db:structure:load
bundle exec rake db:migrate
bundle exec rake db:seed
