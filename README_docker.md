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

```bash
✘ 16:16 ~/code/GIT/subpop [development|✚ 3] $ docker-compose build
db uses an image, skipping
Building web
Step 1 : FROM ruby:2.2.4
 ---> 9168c99105ac
...
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

Push the delayedjob and web images to the repository:

```
emeryrdev02[~]$ docker push localhost:5000/subpop_delayedjob
....
emeryrdev02[~]$ docker push localhost:5000/subpop_web
....
emeryrdev02[~]$
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
...
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
