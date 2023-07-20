FROM internetee/ruby:3.2.2 as base

RUN npm install -g yarn@latest
COPY --link Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5
COPY --link package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM base

ENV LANG et_EE.UTF-8
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc -s | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update > /dev/null && apt-get install -y --no-install-recommends > /dev/null \
    postgresql-client-13=* \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Run and own the application files as a non-root user for security
RUN useradd rails
RUN mkdir -p /home/rails && chown rails:rails /home/rails

USER rails:rails

RUN mkdir -p /opt/webapps/app/tmp/pids 

# Copy built artifacts: gems, application
COPY --from=base --chown=rails:rails /usr/local/bundle /usr/local/bundle
COPY --from=base --chown=rails:rails /opt/webapps/app /opt/webapps/app

EXPOSE 3000
