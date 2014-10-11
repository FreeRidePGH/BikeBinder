Airbrake.configure do |config|
  config.api_key = ENV['ERRAPIKEY']
  config.host    = 'err.frbp.org'
  config.port    = 80
  config.secure  = config.port == 443
end
