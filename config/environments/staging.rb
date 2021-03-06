Pbt4::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true
  config.cache_store = :file_store , "tmp/cache/"
  config.eager_load = true
  config.assets.compile = false
  config.static_cache_control = "public, max-age=2592000"
  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.assets.precompile += %w( .svg .eot .woff .ttf)
  # See everything in the log (default is :info)
  # config.log_level = :debug
  config.eager_load  = true
  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  config.assets.js_compressor = :uglifier
  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  config.assets.precompile += %w( vendor/modernizr )
  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false
  config.static_cache_control = "public, max-age=2592000"
  config.assets.digest = true
  
  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!
end
