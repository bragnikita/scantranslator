require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
  else
    config.storage = :fog
    config.fog_provider = 'fog/aws' # required
    config.fog_credentials = {
      provider: 'AWS', # required
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"], # required
      aws_secret_access_key: ENV["AWS_ACCESS_KEY"], # required
      region: 'ap-northeast-1', # optional, defaults to 'us-east-1'
      host: 's3-ap-northeast-1.amazonaws.com'
    }
    config.fog_directory = 'haji-blog-resources' # required
    config.fog_public = true # optional, defaults to true
    config.fog_attributes = {cache_control: "public, max-age=#{365.day.to_i}"} # optional, defaults to {}
  end
end
