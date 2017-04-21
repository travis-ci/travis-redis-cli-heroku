# travis-redis-cli-heroku

redis-cli in a dyno

## Usage

    $ heroku run travis-redis-cli
    $ heroku run travis-redis-cli travis-production

    $ heroku run travis-redis-cli travis-production REDIS_URL
    my-amazing-redis.computer:12345>

## Install (local)

    $ git clone https://github.com/travis-ci/travis-redis-cli-heroku
    $ cd travis-redis-cli-heroku
    $ heroku git:remote -a travis-redis-cli

## Install (heroku)

    $ heroku config:set HEROKU_ACCESS_TOKEN=...
    $ heroku config:set HEROKU_APPS=...

    $ heroku buildpacks:add --index 1 https://github.com/heroku/heroku-buildpack-apt
    $ heroku buildpacks:add https://github.com/heroku/heroku-buildpack-ruby
