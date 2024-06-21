FROM internetee/ruby:3.2.2-refactor as base

RUN npm install -g yarn@latest
COPY --link Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5
COPY --link package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM base

RUN useradd rails
RUN mkdir -p /home/rails && chown rails:rails /home/rails

USER rails:rails

RUN mkdir -p /opt/webapps/app/tmp/pids 

COPY --from=base --chown=rails:rails /usr/local/bundle /usr/local/bundle
COPY --from=base --chown=rails:rails /opt/webapps/app /opt/webapps/app

EXPOSE 3000
