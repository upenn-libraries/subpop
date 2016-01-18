# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

## Software version

Ruby v2.2.3

Rails 4.2.4


* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.

# Install

Install Docker Machine:

- <https://docs.docker.com/machine/install-machine/>

Follow these instructions for setting up Rails with `docker-compose`:

> Based on instructions here: <https://docs.docker.com/compose/rails/>
>

### Exceptions

Add `Dockerfile`:

```
FROM ruby:2.2.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /subpop
WORKDIR /subpop
ADD Gemfile /subpop/Gemfile
RUN bundle install
ADD . /subpop
```

Add bootstrap `Gemfile`:

```
source 'https://rubygems.org'
gem 'rails', '4.2.0'
```

Add `docker-compose.yml`:

```yml
db:
  image: mysql/mysql-server:5.7
  env_file: .docker-environment
  ports:
    - "3306:3306"
web:
  build: .
  command: bundle exec rails s -p 3000 -b '0.0.0.0'
  volumes:
    - .:/subpop
  ports:
    - "3000:3000"
  links:
    - db
```

Add `.docker-environment`:

```bash
MYSQL_ROOT_PASSWORD=fillthisin
```

Run `docker-compose run` to create containers:

```bash
docker-compose run web rails new . --force --database=mysql --skip-bundle --skip-test-unit
```

Replace `Gemfile` with:

```ruby
source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use mysql as the database for Active Record
# Ugh, Rails 4.2.4 is broken w/r/t/ mysql2 gem > 0.3.x
gem 'mysql2', '~> 0.3.18'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
```

Build the app:

```bash
docker-compose build
```

Replace `config/database.yml` with:

```yaml
# MySQL.  Versions 5.0+ are recommended.
#
# Install the MYSQL driver
#   gem install mysql2
#
# Ensure the MySQL gem is defined in your Gemfile
#   gem 'mysql2'
#
# And be sure to use new-style password hashing:
#   http://dev.mysql.com/doc/refman/5.0/en/old-client.html
#
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: root
  password: <%= ENV['MYSQL_ROOT_PASSWORD'] %>
  host: db

development:
  <<: *default
  database: subpop

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: subpop_test

# As with config/secrets.yml, you never want to store sensitive information,
# like your database password, in your source code. If your source code is
# ever seen by anyone, they now have access to your database.
#
# Instead, provide the password as a unix environment variable when you boot
# the app. Read http://guides.rubyonrails.org/configuring.html#configuring-a-database
# for a full rundown on how to provide these environment variables in a
# production deployment.
#
# On Heroku and other platform providers, you may have a full connection URL
# available as an environment variable. For example:
#
#   DATABASE_URL="mysql2://myuser:mypass@localhost/somedatabase"
#
# You can use this database configuration with:
#
#   production:
#     url: <%= ENV['DATABASE_URL'] %>
#
production:
  <<: *default
  database: subpop
  username: subpop
  password: <%= ENV['SUBPOP_DATABASE_PASSWORD'] %>

```

Boot the app:

```bash
docker-compose up
```



# RSPEC
Add the following to the Gemfile test, development groups:

```ruby
group :development, :test do
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'rb-fsevent' if `uname` =~ /Darwin/
end
```

`$ bundle install`

`$ rails g rspec:install`

# GUARD

`$ guard init`

Change guard invocation line from:

```ruby
guard :rspec, cmd: "bundle exec rspec" do
```

to:

```ruby
guard :rspec, cmd:"spring rspec" do
```

# BOOTSTRAP

The following instructions taken fromx
<http://www.gotealeaf.com/blog/integrating-rails-and-bootstrap-part-1>.

Add the gems:

```ruby
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
```

`$ bundle install`

Rename `app/assets/stylesheets/application.css` to
`app/assets/stylesheets/application.css.sass`

```bash
$ mv app/assets/stylesheets/application.css \
        app/assets/stylesheets/application.css.sass
```

Add the imports to `app/assets/stylesheets/application.css.sass`

```sass
@import "bootstrap-sprockets"
@import "bootstrap"
```

To `app/assets/javascripts/application.js` add the following after the
jQuery import:

```js
//= require bootstrap-sprockets
```

It should look like this when done:

```js
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
```

# Markdown over rdoc for readme

rename README.rdoc -> README.md

# SIMPLE FORM

Add simple form gem:

```ruby
gem 'simple_form'
```

Run bundle install:

```bash
$ bundle install
```

Make simple_form use bootstrap:

```bash
$ rails generate simple_form:install --bootstrap
```

# MYSQL2

Remove sqlite3 and add mysql2 database gem.


```ruby
# Use sqlite3 as the database for Active Record
# gem 'sqlite3' # nope: de 20150113

# Add mysql2 adapter - de 20150113
gem 'mysql2'
```

Run bundle install:

```bash
$ bundle install
```

Replace config/database.yml contents with:

```yaml
# Using mysql2 gem:
#
# gem 'mysql2'
#
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  timeout: 5000

development:
  <<: *default
  database: pop_development
  username: root
  password:

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: pop_test
  username: root
  password:

production:
  <<: *default
  database: pop
  username: popuser
  password: ENV['POP_DB_PASSWORD']
```

Try to create the database:

```bash
$ rake db:create
```

Now, try to connect to the database:

```bash
$ mysql pop_development -u root -p
Enter password:  # <-- password is blank; hit enter
# blah, blah, blah
mysql> \r
Connection id:    6450
Current database: pop_development

```

The database is empty, but you should be able to connect to it.

# DEVISE

Add devise to Gemfile:

```ruby
gem 'devise'
```

Run bundle install:

```bash
$ bundle install
```

Generate the initializer:

```bash
$ rails generate devise:install
```

Be sure to follow configuration instructions:

===============================================================================

    Some setup you must do manually if you haven't yet:

      1. Ensure you have defined default url options in your environments files. Here
         is an example of default_url_options appropriate for a development environment
         in config/environments/development.rb:

           config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

         In production, :host should be set to the actual host of your application.

      2. Ensure you have defined root_url to *something* in your config/routes.rb.
         For example:

           root to: "home#index"

      3. Ensure you have flash messages in app/views/layouts/application.html.erb.
         For example:

           <p class="notice"><%= notice %></p>
           <p class="alert"><%= alert %></p>

      4. If you are deploying on Heroku with Rails 3.2 only, you may want to set:

           config.assets.initialize_on_precompile = false

         On config/application.rb forcing your application to not access the DB
         or load models when precompiling your assets.

      5. You can copy Devise views (for customization) to your app by running:

           rails g devise:views

===============================================================================

Edit config files as described above:

```ruby
  # config/environments/development.rb

  # Devise stuff
  # Ensure you have defined default url options in your environments files. Here
  # is an example of default_url_options appropriate for a development environment
  # in config/environments/development.rb:
  # In production, :host should be set to the actual host of your application.
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

```ruby
  # config/environments/production.rb

  # Devise stuff
  # Ensure you have defined default url options in your environments files. Here
  # is an example of default_url_options appropriate for a development environment
  # in config/environments/development.rb:
  #
  #     config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  #
  # In production, :host should be set to the actual host of your application.
  # TODO: set production host for action_mailer
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

Add add a welcome#index controller and action for root:

```bash
$ rails g controller welcome index
```

Set the root in config/routes.rb to this action:

```ruby
# config/routes.rb

# You can have the root of your site routed with "root"
root to: 'welcome#index'
```

Start the rails server and make sure the route is working:

```bash
$ rails s
```

Now go to <http://localhost:3000>.

If it's working, then create the devise model and migrate the database.

```bash
$ rails generate devise user
      invoke  active_record
      create    db/migrate/20150113222857_devise_create_users.rb
      create    app/models/user.rb
      invoke    rspec
      create      spec/models/user_spec.rb
      insert    app/models/user.rb
       route  devise_for :users

$ rake db:migrate
```

See devise github page for configuring devise:

- <https://github.com/plataformatec/devise#controller-filters-and-helpers>
