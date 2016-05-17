# Docker ReadMe for subpop #

These are instructions for building subpop with `docker-compose` and
pushing it to the `emeryrdev02` server.

## Set up SSH tunnel to remote ##

Tunnel to `emeryrdev02`, forwarding port `2375` to localhost:

```bash
$ ssh -fnNL 2375:localhost:2375 emeryrdev02
```

Note that the local user `emeryr` is the same on `emeryrdev02`.

Alternately, config the tunnel as host in `$HOME/.ssh/config`, as below, with
correct values for `hostname`, `the.key`, and `user_name`. `User_name` is not
required if it's the same on both hosts.

```
Host docker-tunnel
   HostName hostname
   IdentityFile ~/.ssh/the.key
   LocalForward 2375 127.0.0.1:2375
   User: user_name
```

Then you can do: 

```bash
$ ssh -f -N docker-tunnel
```

## Build with docker-compose ##

Set `DOCKER_HOST` environment variable in bash init file:

```bash
export DOCKER_HOST=localhost:2375
```

Be sure `DOCKER_HOST` is set the local environment and run `docker-compose`. 

**IMPORTANT**: Note the `: > Gemfile.lock`. If this file is not empty, bundle will 
attempt to use conflicting gem versions at runtime.

```bash
✘ 16:16 ~/code/GIT/subpop [development|✚ 3] $ : > Gemfile.lock && \
    docker-compose build
db uses an image, skipping
Building web
Step 1 : FROM ruby:2.2.4
 ---> 9168c99105ac
Step 2 : RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
 ---> Using cache
 ---> 70959490eb9d
Step 3 : WORKDIR /subpop
 ---> Using cache
 ---> a1f7d50bd2cb
Step 4 : COPY Gemfile /subpop/Gemfile
 ---> cf417cfa1d20
Removing intermediate container 576a0dbba359
Step 5 : RUN bundle install
 ---> Running in a676f9afab96
Fetching gem metadata from https://rubygems.org/...........
Fetching version metadata from https://rubygems.org/...
Fetching dependency metadata from https://rubygems.org/..
Resolving dependencies............................................\
..................................................................\
................................................................
Installing rake 11.1.2
Installing i18n 0.7.0
Installing json 1.8.3 with native extensions
# ... snip ...
Installing rails-jquery-autocomplete 1.0.3
Installing jquery-turbolinks 2.1.0
Bundle complete! 34 Gemfile dependencies, 110 gems now installed.
Bundled gems are installed into /usr/local/bundle.
Post-install message from rdoc:
Depending on your version of ruby, you may need to install ruby rdoc/ri data:

<= 1.8.6 : unsupported
 = 1.8.7 : gem install rdoc-data; rdoc-data --install
 = 1.9.1 : gem install rdoc-data; rdoc-data --install
>= 1.9.2 : nothing to do! Yay!
 ---> 478c86dcb7bb
Removing intermediate container a676f9afab96
Step 6 : ADD . /subpop
 ---> 1a4205b4b22b
Removing intermediate container 4396205912df
Step 7 : ENV RAILS_ENV production
 ---> Running in 828f279c99c3
 ---> faa4ef88d40c
Removing intermediate container 828f279c99c3 
Step 8 : RUN SUBPOP_DEVISE_SECRET_KEY=dummy \
    SUBPOP_FLICKR_API_KEY=dummy \
    SUBPOP_FLICKR_API_SECRET=dummy \
    SUBPOP_FLICKR_ACCESS_TOKEN=dummy \
    SUBPOP_FLICKR_ACCESS_SECRET=dummy \
    SUBPOP_FLICKR_USERID=dummy \
    SUBPOP_FLICKR_USERNAME=dummy \
    RAILS_ENV=production \
    bundle exec rake assets:precompile --trace
 ---> Running in cf0eea540471
** Invoke assets:precompile (first_time)
** Invoke assets:environment (first_time)
** Execute assets:environment
** Invoke environment (first_time)
** Execute environment
** Execute assets:precompile
I, [2016-05-10T20:25:04.548296 #6]  INFO -- : Writing /subpop/public/assets/application-3159e5d817a97874c057e7918c41b7125a89db218da0656d8705375a1e71fd65.js
I, [2016-05-10T20:25:04.550203 #6]  INFO -- : Writing /subpop/public/assets/application-3159e5d817a97874c057e7918c41b7125a89db218da0656d8705375a1e71fd65.js.gz
I, [2016-05-10T20:25:17.877779 #6]  INFO -- : Writing /subpop/public/assets/application-feee4be1322719011a8b9a8f484bba7edf6972debd5ff6fe8209dd7279ee27dc.css
I, [2016-05-10T20:25:17.878117 #6]  INFO -- : Writing /subpop/public/assets/application-feee4be1322719011a8b9a8f484bba7edf6972debd5ff6fe8209dd7279ee27dc.css.gz
I, [2016-05-10T20:25:17.879188 #6]  INFO -- : Writing /subpop/public/assets/bootstrap/glyphicons-halflings-regular-13634da87d9e23f8c3ed9108ce1724d183a39ad072e73e1b3d8cbf646d2d0407.eot
I, [2016-05-10T20:25:17.879457 #6]  INFO -- : Writing /subpop/public/assets/bootstrap/glyphicons-halflings-regular-13634da87d9e23f8c3ed9108ce1724d183a39ad072e73e1b3d8cbf646d2d0407.eot.gz
I, [2016-05-10T20:25:17.880035 #6]  INFO -- : Writing /subpop/public/assets/bootstrap/glyphicons-halflings-regular-fe185d11a49676890d47bb783312a0cda5a44c4039214094e7957b4c040ef11c.woff2
I, [2016-05-10T20:25:17.881336 #6]  INFO -- : Writing /subpop/public/assets/bootstrap/glyphicons-halflings-regular-a26394f7ede100ca118eff2eda08596275a9839b959c226e15439557a5a80742.woff
I, [2016-05-10T20:25:17.881945 #6]  INFO -- : Writing /subpop/public/assets/bootstrap/glyphicons-halflings-regular-e395044093757d82afcb138957d06a1ea9361bdcf0b442d06a18a8051af57456.ttf
I, [2016-05-10T20:25:17.882361 #6]  INFO -- : Writing /subpop/public/assets/bootstrap/glyphicons-halflings-regular-e395044093757d82afcb138957d06a1ea9361bdcf0b442d06a18a8051af57456.ttf.gz
I, [2016-05-10T20:25:17.883031 #6]  INFO -- : Writing /subpop/public/assets/bootstrap/glyphicons-halflings-regular-42f60659d265c1a3c30f9fa42abcbb56bd4a53af4d83d316d6dd7a36903c43e5.svg
I, [2016-05-10T20:25:17.884683 #6]  INFO -- : Writing /subpop/public/assets/bootstrap/glyphicons-halflings-regular-42f60659d265c1a3c30f9fa42abcbb56bd4a53af4d83d316d6dd7a36903c43e5.svg.gz
 ---> b16ad3789c1c
Removing intermediate container cf0eea540471
Step 9 : CMD [ "rm", "-f" "/subpop/tmp/pids/server.pid"]
 ---> Running in c21b8ef3c682
 ---> 2bb782fa097a
Removing intermediate container c21b8ef3c682
Step 10 : CMD rails server -b 0.0.0.0
 ---> Running in 88bbd2438bf9
 ---> 1248b12cd4c9
Removing intermediate container 88bbd2438bf9
Successfully built 1248b12cd4c9
Building delayedjob
Step 1 : FROM ruby:2.2.4
 ---> 9168c99105ac
Step 2 : RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
 ---> Using cache
 ---> 70959490eb9d
Step 3 : WORKDIR /subpop
 ---> Using cache
 ---> a1f7d50bd2cb
Step 4 : COPY Gemfile /subpop/Gemfile
 ---> Using cache
 ---> cf417cfa1d20
Step 5 : RUN bundle install
 ---> Using cache
 ---> 478c86dcb7bb
Step 6 : ADD . /subpop
 ---> Using cache
 ---> 1a4205b4b22b
Step 7 : ENV RAILS_ENV production
 ---> Using cache
 ---> faa4ef88d40c
Step 8 : RUN SUBPOP_DEVISE_SECRET_KEY=dummy \
    SUBPOP_FLICKR_API_KEY=dummy \
    SUBPOP_FLICKR_API_SECRET=dummy \
    SUBPOP_FLICKR_ACCESS_TOKEN=dummy \
    SUBPOP_FLICKR_ACCESS_SECRET=dummy \
    SUBPOP_FLICKR_USERID=dummy \
    SUBPOP_FLICKR_USERNAME=dummy \
    RAILS_ENV=production \
    bundle exec rake assets:precompile --trace
 ---> Using cache
 ---> b16ad3789c1c
Step 9 : CMD [ "rm", "-f" "/subpop/tmp/pids/server.pid"]
 ---> Using cache
 ---> 2bb782fa097a
Step 10 : CMD rails server -b 0.0.0.0
 ---> Using cache
 ---> 1248b12cd4c9
Successfully built 1248b12cd4c9
```

