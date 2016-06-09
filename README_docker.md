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
## Tag and push docker-images on remote server

Log in to remote server, e.g., `emeryrdev02`.

Tag the web and delayedjob images:

```
emeryrdev02[~]$ docker images
REPOSITORY                           TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
subpop_delayedjob                    latest              2b44b46993a4        14 minutes ago      905 MB
subpop_web                           latest              2b44b46993a4        14 minutes ago      905 MB
localhost:5000/subpop_web            latest              d82916b4eba2        2 weeks ago         905 MB
localhost:5000/subpop_delayedjob     latest              d82916b4eba2        2 weeks ago         905 MB
...
emeryrdev02[~]$ docker tag -f 2b44b46993a4 localhost:5000/subpop_delayedjob
emeryrdev02[~]$ docker tag -f 2b44b46993a4 localhost:5000/subpop_web
```

> Note the `-f` flag to force the reassignment of the tag to a new image.

Push the delayedjob image to the repository:

```
emeryrdev02[~]$ docker push localhost:5000/subpop_delayedjob
The push refers to a repository [localhost:5000/subpop_delayedjob] (len: 1)
Sending image list
Pushing repository localhost:5000/subpop_delayedjob (1 tags)
Image 004814f54a9a already pushed, skipping
Image b6b57a59043e already pushed, skipping
Image 70e9a6907f10 already pushed, skipping
Image b478bcf89851 already pushed, skipping
Image 783fdfa6305f already pushed, skipping
Image 4786bcc15aac already pushed, skipping
Image bd7b40057a50 already pushed, skipping
Image 63136362925b already pushed, skipping
Image 125a6ca962cf already pushed, skipping
Image 37ed6f9f3092 already pushed, skipping
Image 4178b2a91377 already pushed, skipping
Image 32f2a4cccab8 already pushed, skipping
Image cc129c95131a already pushed, skipping
Image 3726859b22df already pushed, skipping
Image a9e5ef3759ec already pushed, skipping
Image 9168c99105ac already pushed, skipping
Image 5fe7a16dfa05 already pushed, skipping
Image 70959490eb9d already pushed, skipping
Image a1f7d50bd2cb already pushed, skipping
Image f0f1a61c2eaf already pushed, skipping
Image 478c86dcb7bb already pushed, skipping
Image cf417cfa1d20 already pushed, skipping
df07c4daad91: Image successfully pushed
362de763a33e: Image successfully pushed
4e227afa4ac5: Image successfully pushed
2b44b46993a4: Image successfully pushed
Pushing tag for rev [2b44b46993a4] on {http://localhost:5000/v1/repositories/subpop_delayedjob/tags/latest}

```

Push the web image to the repository:

```
emeryrdev02[~]$ docker push localhost:5000/subpop_web
The push refers to a repository [localhost:5000/subpop_web] (len: 1)
Sending image list
Pushing repository localhost:5000/subpop_web (1 tags)
Image b6b57a59043e already pushed, skipping
Image 004814f54a9a already pushed, skipping
Image b478bcf89851 already pushed, skipping
Image 4786bcc15aac already pushed, skipping
Image 32f2a4cccab8 already pushed, skipping
Image 783fdfa6305f already pushed, skipping
Image 70e9a6907f10 already pushed, skipping
Image 4178b2a91377 already pushed, skipping
Image 125a6ca962cf already pushed, skipping
Image bd7b40057a50 already pushed, skipping
Image 37ed6f9f3092 already pushed, skipping
Image 63136362925b already pushed, skipping
Image cc129c95131a already pushed, skipping
Image a9e5ef3759ec already pushed, skipping
Image 5fe7a16dfa05 already pushed, skipping
Image 70959490eb9d already pushed, skipping
Image f0f1a61c2eaf already pushed, skipping
Image a1f7d50bd2cb already pushed, skipping
Image cf417cfa1d20 already pushed, skipping
Image 9168c99105ac already pushed, skipping
Image 478c86dcb7bb already pushed, skipping
Image 3726859b22df already pushed, skipping
Image df07c4daad91 already pushed, skipping
Image 4e227afa4ac5 already pushed, skipping
Image 362de763a33e already pushed, skipping
Image 2b44b46993a4 already pushed, skipping
Pushing tag for rev [2b44b46993a4] on {http://localhost:5000/v1/repositories/subpop_web/tags/latest}
```

List the images:

```bash
emeryrdev02[~]$ docker images
REPOSITORY                           TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
subpop_delayedjob                    latest              2b44b46993a4        15 minutes ago      905 MB
subpop_web                           latest              2b44b46993a4        15 minutes ago      905 MB
localhost:5000/subpop_web            latest              2b44b46993a4        15 minutes ago      905 MB
localhost:5000/subpop_delayedjob     latest              2b44b46993a4        15 minutes ago      905 MB
...
```

## Run the application

Clone the `subpop-docker` project on the deployment server:

```
$ git clone ssh://git@gitlab.library.upenn.edu:2222/emeryr/subpop-docker.git
```

Copy a `.docker-environment` file into the `subpop-docker` folder. The file should
look like this:

```bash
MYSQL_ROOT_PASSWORD=REPLACEME
RAILS_ENV=production
RAILS_SERVE_STATIC_FILES=true
# DEV POP Flickr site keys
SUBPOP_FLICKR_API_KEY=REPLACEME
SUBPOP_FLICKR_API_SECRET=REPLACEME
SUBPOP_FLICKR_ACCESS_TOKEN=REPLACEME
SUBPOP_FLICKR_ACCESS_SECRET=REPLACEME

SUBPOP_FLICKR_USERID=REPLACEME
SUBPOP_FLICKR_USERNAME=REPLACEME

SUBPOP_DB_NAME=subpop
SUBPOP_DB_USER=root
SUBPOP_DB_PASSWORD=$MYSQL_ROOT_PASSWORD

SUBPOP_DEVISE_SECRET_KEY=REPLACEME

SUBPOP_SECRET_TOKEN=REPLACEME
SUBPOP_SECRET_KEY_BASE=REPLACEME
```

Stop any running process:

```
emeryrdev02[~]$ cd subpop-docker
emeryrdev02[~/subpop-docker]$ sudo docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                               NAMES
d979cde84ff0        d82916b4eba2             "bundle exec rake job"   2 weeks ago         Up 13 days                                              subpopdocker_delayedjob_1
88302d1d7c6f        d82916b4eba2             "rails server -b 0.0."   2 weeks ago         Up 13 days          0.0.0.0:80->3000/tcp                subpopdocker_web_1
9e6b03328e71        mysql/mysql-server:5.7   "/entrypoint.sh mysql"   3 weeks ago         Up 13 days          0.0.0.0:3306->3306/tcp, 33060/tcp   subpopdocker_db_1
emeryrdev02[~/subpop-docker]$ sudo docker-compose stop
Stopping subpopdocker_delayedjob_1 ... done
Stopping subpopdocker_web_1 ... done
Stopping subpopdocker_db_1 ... done
emeryrdev02[~/subpop-docker]$ 
```

In a screen session, start the docker process:

```
emeryrdev02[~/subpop-docker]$ sudo docker-compose up
Starting subpopdocker_db_1
Starting subpopdocker_data_1
Recreating subpopdocker_web_1
Recreating subpopdocker_delayedjob_1
Attaching to subpopdocker_db_1, subpopdocker_data_1, subpopdocker_web_1, subpopdocker_delayedjob_1
subpopdocker_data_1 exited with code 0
web_1        | Array values in the parameter to `Gem.paths=` are deprecated.
web_1        | Please use a String or nil.
web_1        | An Array ({"GEM_PATH"=>["/usr/local/bundle"]}) was passed in from bin/rails:3:in `load'
web_1        | => Booting Puma
web_1        | => Rails 4.2.5 application starting in production on http://0.0.0.0:3000
web_1        | => Run `rails server -h` for more startup options
web_1        | => Ctrl-C to shutdown server
delayedjob_1 | [Worker(host:0c4eac4edced pid:1)] Starting job worker
delayedjob_1 | I, [2016-06-06T14:53:21.457020 #1]  INFO -- : 2016-06-06T14:53:21+0000: [Worker(host:0c4eac4edced pid:1)] Starting job worker
web_1        | Puma starting in single mode...
web_1        | * Version 3.4.0 (ruby 2.2.4-p230), codename: Owl Bowl Brawl
web_1        | * Min threads: 0, max threads: 16
web_1        | * Environment: production
web_1        | * Listening on tcp://0.0.0.0:3000
web_1        | Use Ctrl-C to stop
```

If needed, run `rake db:migrate`:

```
emeryrdev02[~/subpop-docker]$ sudo docker-compose run web rake db:migrate
```
