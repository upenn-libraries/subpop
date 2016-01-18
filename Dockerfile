FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /subpop
WORKDIR /subpop
ADD Gemfile /subpop/Gemfile
RUN bundle install
ADD . /subpop
