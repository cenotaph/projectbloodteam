Pbt4::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true
  config.eager_load = false
  # Show full error reports and disable caching
  config.consider_all_requests_local       = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :redis_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end
  
  config.active_support.deprecation = :log 
  config.asset_host = Proc.new { |source|
    if source.starts_with?('/images')
      "http://bloodteam.com"
    else
      "http://localhost:3000"
    end
    }

  # config.after_initialize do
  #   Bullet.enable = true
  #   Bullet.alert = true
  #   Bullet.bullet_logger = true
  #   Bullet.console = true
  #   Bullet.growl = false
  #   Bullet.rails_logger = true
  # end
  config.paperclip_defaults = {
    :storage => :s3,
    :bucket => 'pbt-production',
    :s3_permissions => 'public-read',
    :s3_region => 'us-east-1'
  }
  # Don't care if the mailer can't send
  config.active_record.raise_in_transactional_callbacks = true
  config.action_mailer.raise_delivery_errors = false
end
# ActionController::Base.asset_host = Proc.new { |source|
#     if source.starts_with?('/images')
#       "http://bloodteam.com"
#     else
#       "http://localhost:3000"
#     end
# }
# ActiveSupport::Dependencies.explicitly_unloadable_constants.concat(Dir.glob("#{Rails.root}/app/helpers/**/*.rb").map {|file| File.basename(file, '.rb').camelize})