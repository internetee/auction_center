FROM internetee/ruby:2.4
MAINTAINER maciej.szlosarczyk@internet.ee

RUN npm install -g yarn
RUN mkdir -p /opt/webapps/current/tmp/pids
WORKDIR /opt/webapps/app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

EXPOSE 3000
