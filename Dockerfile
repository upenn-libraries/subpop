FROM ruby:2.2.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

WORKDIR /subpop
COPY Gemfile /subpop/Gemfile

RUN bundle install

ADD . /subpop

CMD ["rails", "server"]
