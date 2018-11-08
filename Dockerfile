FROM internetee/ruby:2.5-stretch
MAINTAINER maciej.szlosarczyk@internet.ee

RUN npm install -g yarn
RUN mkdir -p /opt/webapps/current/tmp/pids
WORKDIR /opt/webapps/app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5
COPY package.json yarn.lock ./
RUN yarn install

EXPOSE 3000
