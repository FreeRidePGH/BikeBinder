require File.expand_path(File.join("..","..","directories.rb"), __FILE__)
Airbrake.configure do |config|
  if ENV["ERR_API_KEY"] && ENV["ERR_API_KEY"].length > 0
    config.api_key = ENV["ERR_API_KEY"].strip
  elsif File.exists?(ERR_API_KEY)
    config.api_key = File.read(File.expand_path(ERR_API_KEY)).strip
  end

  config.host    = 'err.frbp.org'
  config.port    = 80
  config.secure  = config.port == 443
  config.user_attributes = [:id, :email]
end
