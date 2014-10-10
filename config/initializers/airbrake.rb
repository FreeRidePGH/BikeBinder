Airbrake.configure do |config|
  config.api_key = 'eca00910541c8b3d9c6f15c61f2d113c'
  config.host    = 'frbp-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
