# FROM internetee/ruby:3.0-buster

# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install wkhtmltopdf -y > /dev/null

# RUN npm install -g yarn@latest
# WORKDIR /opt/webapps/app
# COPY Rakefile Gemfile Gemfile.lock ./
# RUN gem install bundler && bundle install --jobs 20 --retry 5
# COPY package.json yarn.lock ./
# RUN yarn install --check-files


FROM ruby:3.0.2-slim-buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update > /dev/null && apt-get install -y --no-install-recommends > /dev/null \
    build-essential=* \
    imagemagick=* \
    curl \
    wget \
    gnupg2 \
    git \
    apt-utils \
    && apt-get dist-upgrade -yf\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN sed -i -e 's/# et_EE.UTF-8 UTF-8/et_EE.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=et_EE.UTF-8

ENV LANG et_EE.UTF-8
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc -s | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update > /dev/null && apt-get install -y --no-install-recommends > /dev/null \
    postgresql-client-13=* \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# add repository for Node.js in the LTS version
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get install -y --no-install-recommends > /dev/null \
  nodejs=* \
  qt5-default=* \
  libqt5webkit5-dev=* \
  gstreamer1.0-plugins-base=* \
  libappindicator3-1=* \
  gstreamer1.0-tools=* \
  qtdeclarative5-dev=* \
  fonts-liberation=* \
  gstreamer1.0-x=* \
  libasound2=* \
  libnspr4=* \
  libnss3=* \
  libxss1=* \
  libxtst6=* \
  xdg-utils=* \
  qtdeclarative5-dev=* \
  fonts-liberation=* \
  gstreamer1.0-x=* \
  wkhtmltopdf \
  libxslt1-dev \
  libxml2-dev \
  python-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl https://chromedriver.storage.googleapis.com/2.46/chromedriver_linux64.zip -o /chromedriver_linux64.zip
RUN apt-get update > /dev/null \
    && apt-get install -yf --no-install-recommends > /dev/null unzip=* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN unzip chromedriver_linux64.zip -d /usr/local/bin
RUN rm /chromedriver_linux64.zip

# RUN npm install --global yarn
RUN npm install -g yarn@latest

RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN dpkg -i /chrome.deb || apt-get update > /dev/null \
    && apt-get install -yf --no-install-recommends > /dev/null && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN dpkg -i /chrome.deb
RUN rm /chrome.deb
RUN sed -i 's/SECLEVEL=2/SECLEVEL=1/' /etc/ssl/openssl.cnf

RUN mkdir -p /opt/webapps/app/tmp/pids
WORKDIR /opt/webapps/app

COPY Rakefile Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5
COPY package.json yarn.lock ./
RUN yarn install --check-files

EXPOSE 3000
