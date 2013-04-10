# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

require File.expand_path(File.join("..","..","directories.rb"), __FILE__)
if ENV["BIKE_BINDER_SECRET_TOKEN"].present?
  BikeBinder::Application.config.secret_token = ENV["BIKE_BINDER_SECRET_TOKEN"].strip
elsif File.exists?(APP_SECRET_FILE)
  BikeBinder::Application.config.secret_token = File.read(File.expand_path(APP_SECRET_FILE)).strip
  #raise "ERROR: secret file #{APP_SECRET_FILE} must be generated. Run setup as require."
end

