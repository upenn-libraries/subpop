FROM ruby:2.2.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

WORKDIR /subpop
COPY Gemfile /subpop/Gemfile

RUN bundle install

ADD . /subpop

# We're not setting any of the SUBPOP vars; we just need some dummy information
# so we can precompile the assets.
RUN SUBPOP_DEVISE_SECRET_KEY=dummy \
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
  RAILS_ENV=production \
  bundle exec rake assets:precompile --trace

# Delete old server.pid or it just won't start
CMD [ "rm", "-f" "/subpop/tmp/pids/server.pid"]
CMD ["rails","server","-b","0.0.0.0"]
# CMD ["rake","jobs:work"]
# CMD ["foreman","start"]