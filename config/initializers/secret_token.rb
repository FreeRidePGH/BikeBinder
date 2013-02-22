# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
require 'fileutils'
require File.dirname(__FILE__) + "/../../config/directories.rb"
if ENV["SECRET_TOKEN"]
  BikeBinder::Application.config.secret_token = ENV["SECRET_TOKEN"]
elsif File.exists?(APP_SECRET_FILE)
  BikeBinder::Application.config.secret_token = File.read(APP_SECRET_FILE)
  #raise "ERROR: secret file #{APP_SECRET_FILE} must be generated. Run setup as require."
end

