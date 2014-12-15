require 'amazon/ecs'
Amazon::Ecs.options = {
  :associate_tag => ENV['AMAZON_ASSOC'],
  :AWS_access_key_id => ENV['S3_ACCESS'], 
  :AWS_secret_key => ENV['S3_SECRET']
  }