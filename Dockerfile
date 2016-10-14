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
  file \
  libpq-dev

ENV INSTALL_PATH /subpop

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./

RUN bundle install --binstubs

COPY . .

# We're not setting any of the SUBPOP vars; we just need some dummy information
# so we can precompile the assets.
RUN bundle exec rake \
  RAILS_ENV=production \
  SUBPOP_DEVISE_SECRET_KEY=dummy \
  SUBPOP_FLICKR_API_KEY=dummy \
  SUBPOP_FLICKR_API_SECRET=dummy \
  SUBPOP_FLICKR_ACCESS_TOKEN=dummy \
  SUBPOP_FLICKR_ACCESS_SECRET=dummy \
  SUBPOP_FLICKR_USERID=dummy \
  SUBPOP_FLICKR_USERNAME=dummy \
  SUBPOP_SECRET_KEY_BASE=dummy \
  SUBPOP_SECRET_TOKEN=dummy \
  SUBPOP_EMAIL_FROM=dummy \
  SUBPOP_SMTP_HOST=example.com \
  assets:precompile --trace

VOLUME ["$INSTALL_PATH/public"]
# From the blog:
# In production you will very likely reverse proxy Rails with nginx.
# This sets up a volume so that nginx can read in the assets from
# the Rails Docker image without having to copy them to the Docker host
#
# TODO: Figure out how to handle paperclip images in `public/system`. Use an
# s3 style client?


# Delete old server.pid or it just won't start
CMD [ "rm", "-f" "/subpop/tmp/pids/server.pid"]
CMD ["rails","server","-b","0.0.0.0"]
# CMD ["rake","jobs:work"]
# CMD ["foreman","start"]