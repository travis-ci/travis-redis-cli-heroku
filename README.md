# travis-redis-cli-heroku

## Usage

    heroku run travis-redis-cli
    heroku run travis-redis-cli travis-production
    heroku run travis-redis-cli travis-production REDIS_URL

## Config

    heroku config:set HEROKU_ACCESS_TOKEN=...
    heroku config:set HEROKU_APPS=...

## Install

    heroku buildpacks:add --index 1 https://github.com/heroku/heroku-buildpack-apt
    heroku buildpacks:add https://github.com/heroku/heroku-buildpack-ruby
