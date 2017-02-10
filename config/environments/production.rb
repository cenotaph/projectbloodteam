Pbt4::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true
  config.cache_store = :file_store , "tmp/cache/"
  
  # config.cache_store = :dalli_store
  config.action_controller.perform_caching = true
  
  config.eager_load = true
  config.public_file_server.headers = { 'Cache-Control' => 'public, max-age=2592000' }
  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false

  config.assets.precompile += %w( .svg .eot .woff .ttf)
  # See everything in the log (default is :info)
  config.log_level = :info
  # config.active_record.raise_in_transactional_callbacks = true

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.public_file_server.enabled = true
  config.static_cache_control = "public, max-age=2592000"
  # config.assets.digest = true
  config.paperclip_defaults = {
    :storage => :s3,
    :bucket => 'pbt-production',
    :s3_permissions => 'public-read',
    :s3_region => 'us-east-1'
  }
  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!
end
