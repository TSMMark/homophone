FROM ubuntu:trusty

###
# OS Packages Round 1
###
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
  # needed for `add-apt-repository` to function properly
  apt-transport-https \
  # provides `add-apt-repository` command
  software-properties-common \
  # used before round 2
  wget

###
# OS Packages Round 2
###
# ruby repo
RUN add-apt-repository -y ppa:brightbox/ruby-ng
# nginx repo
RUN add-apt-repository ppa:nginx/stable -y
# Add PostgreSQL repo
RUN add-apt-repository -y "deb https://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"
# Authentication for postgres packages
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
ENV PATH="/usr/lib/postgresql/9.6/bin/:${PATH}"
# refresh list with new repos
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
  build-essential \
  bundler \
  curl \
  git \
  imagemagick \
  libmagickcore-dev \
  libmagickwand-dev \
  libpq-dev \
  libxml2 \
  libxml2-dev \
  libxslt1-dev \
  locales \
  python-software-properties \
  zlib1g-dev \
  # ruby
  ruby2.1 \
  ruby2.1-dev \
  # psql
  libpq-dev \
  postgresql-client-9.6 \
  # nginx
  nginx

###
# Locales
###
RUN locale-gen en_US en_US.UTF-8 cy_GB.UTF-8
ENV LC_ALL=C.UTF-8
ENV LANG=US.UTF-8
ENV LANGUAGE=en_US.UTF-8

###
# Environment variable for code to know if it's running in Docker.  Ideally this is unnecessary but it's not an ideal world, now is it?
# If no code in our codebase references this, it can be removed.
###
ENV USING_DOCKER=true

###
# Networking
###
# map localhost domain so we can oauth with 3rd parties
RUN sed '1s/.*/127.0.0.1 localhost homophone-localhost.com/' /etc/hosts
EXPOSE 80 5000

###
# Node
###
RUN wget https://nodejs.org/download/release/v10.15.1/node-v10.15.1-linux-x64.tar.gz
RUN tar -xf node-v10.15.1-linux-x64.tar.gz --directory /usr/local --strip-components 1
RUN npm config set cache "${HOME}/cache/npm/"
RUN npm install -g gulp@4.x

# ###
# # Yarn
# # From https://yarnpkg.com/en/docs/install#debian-stable
# ###
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
# RUN apt-get update && apt-get -y dist-upgrade
# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install yarn=1.12.3-1

###
# lsof
###
RUN apt-get install lsof

###
# ffmpeg
###
# RUN set -x \
#     && add-apt-repository ppa:mc3man/trusty-media \
#     && apt-get update \
#     && apt-get -y dist-upgrade \
#     && apt-get install -y ffmpeg

###
# ssh
###
RUN apt-get update && apt-get install -y ssh

###
# heroku cli
###
RUN curl https://cli-assets.heroku.com/install.sh | sh

###
# add git remotes (TODO: Automate this)
# fatal: Not a git repository (or any of the parent directories): .git
# ERROR: Service 'web' failed to build: The command '/bin/sh -c git remote rename homophonestaging staging' returned a non-zero code: 128
###
# RUN heroku git:remote -a homophonestaging
# RUN git remote rename homophonestaging staging
# RUN heroku git:remote -a homophone
# RUN git remote rename homophone production

###
# Ruby Gems
###
COPY Gemfile* /tmp/gemfiles/
WORKDIR /tmp/gemfiles
RUN bundle install

# Log in directly to /homophone
WORKDIR /homophone
CMD bash
