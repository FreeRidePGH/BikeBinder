BikeBinder::Application.configure do

  #upgrade to rails 3.2
  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict
 
  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  # setup instructions @ https://github.com/RailsApps/rails3-devise-rspec-cucumber/wiki/Tutorial
  # also see https://www.ruby-forum.com/topic/215482
  # For installing Devise, Ensure you have defined default url options in your environments files. 
  #require 'tlsmail' # http://yekmer.posterous.com/devise-gmail-smtp-configuration
  #Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE) 
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
    :enable_starttls_auto => true,
    :address => 'smtp.gmail.com',
    :port => 587,
    :authentication => :plain,
    :domain => "freeridepgh.org",
    :user_name => "frtest97@gmail.com",
    :password => "M1hjU26cfkCEe3uBr7Fi"
  }
  config.action_mailer.default_url_options= {:host => 'localhost:3000'}

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.serve_static_assets = true
end
