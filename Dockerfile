# 2016-09-30 DE: Updating Dockerfile following Nick Janetakis' "Dockerize a
# Rails 5, Postgres, Redis, Sidekiq and Action Cable Application":
#
#   http://nickjanetakis.com/blog/dockerize-a-rails-5-postgres-redis-sidekiq-action-cable-app-with-docker-compose
#
FROM ruby:2.2.5-slim

MAINTAINER Doug Emery <emeryr@upenn.edu>

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  libmysqlclient-dev \
  build-essential \
  imagemagick \
  file

ENV INSTALL_PATH /subpop

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./

RUN bundle install --binstubs --without development test

COPY . .

# Delete old server.pid or it just won't start
CMD [ "rm", "-f", "/subpop/tmp/pids/server.pid"]
CMD ["rails","server","-b","0.0.0.0"]
# CMD ["rake","jobs:work"]
# CMD ["foreman","start"]
