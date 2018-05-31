require 'platform-api'
require 'concurrent'
require 'uri'
require 'shellwords'

if !ENV['HEROKU_ACCESS_TOKEN']
  puts "error: please provide HEROKU_ACCESS_TOKEN env var"
  exit 1
end

if !ENV['HEROKU_APPS']
  puts "error: please provide HEROKU_APPS env var"
  exit 1
end

heroku = PlatformAPI.connect_oauth(ENV['HEROKU_ACCESS_TOKEN'])
apps = ENV['HEROKU_APPS'].split(' ')

selected_app = ARGV.shift
selected_var = ARGV.shift

if selected_app
  apps = [selected_app]
end

if selected_app && selected_var
  app = selected_app
  config = heroku.config_var.info_for_app(app)

  redis_url = config[selected_var]
  redis_uri = URI(redis_url)

  if !ENV['DYNO']
    puts "not running on heroku, refusing to connect via plaintext over the internet"
    exit 1
  end

  exec "redis-cli -a #{redis_uri.password.shellescape} -h #{redis_uri.host.shellescape} -p #{redis_uri.port} #{ARGV.map(&:shellescape).join(' ')}"
end

futures = []

apps.each do |app|
  futures << Concurrent::Future.execute{
    addons = heroku.addon.list_by_app(app)
      .select { |addon| addon['addon_service']['name'].include? 'redis' }

    url_vars = addons.map { |addon|
      addon['config_vars'].select { |k,v| k.include?('_URL') }.first
    }.flatten

    [app, url_vars]
  }
end

futures.each do |f|
  app, url_vars = f.value
  puts app
  url_vars&.each do |k,v|
    puts "  #{k}"
  end
end
