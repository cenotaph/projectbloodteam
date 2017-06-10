require 'amazon/ecs'
Amazon::Ecs.configure do |options|
  # options[:associate_tag] = ENV['AMAZON_ASSOC']
  options[:AWS_access_key_id] = ENV['S3_ACCESS']
  options[:AWS_secret_key] =  ENV['S3_SECRET']
end