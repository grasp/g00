G0::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true
  
  #log rotation
 # config.logger = Logger.new("#{Rails.root}/log/#{Rails.env}#{Date.today.to_s}.log", "daily")

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
 # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log
  config.cache_store = :redis_store
  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
#  config.paths.log="/d/vob/g00/log/#{Rails.env}.log"
 # config.paths.log="/var/log/rails/#{Rails.env}.log"
 
  # Do not compress assets
config.assets.compress = false
 
# Expands the lines which load the assets
#config.assets.debug = true
config.assets.debug = false
 config.log_level = :info
  
  Gmaps4rails.http_proxy = "http://wwwgate0-ch.mot.com:1080"
  
  config.action_dispatch.rack_cache = {:verbose => false}
end

