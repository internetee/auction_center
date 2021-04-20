FROM internetee/ruby:2.7

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install wkhtmltopdf -y > /dev/null

RUN npm install -g yarn@latest
WORKDIR /opt/webapps/app
COPY Rakefile Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5
COPY package.json yarn.lock ./
RUN yarn install --check-files
