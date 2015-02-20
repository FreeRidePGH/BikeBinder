Rails.application.configure do

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Debug mode disables concatination and preprocessing of assets
  # This option may cause significant delays in view rendering with a large
  # number of complex layouts
  config.assets.debug = true

  # Do not compress assets
  config.assets.compress = false

  config.serve_static_assets = true

  # Assets digest allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire then through the digets params.
  config.assets.digest = true

  # Allow local precompile of assets
  config.assets.prefix = "/dev-assets"

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies
  # Raises helpful error messages.
  config.assets.rais_runtime_errors = true
  
  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # override for development
  config.action_mailer.default_url_options= {:host => "localhost:3000"}

  # Send email in development mode.
  config.action_mailer.perform_deliveries = true

  # Raise error for missing translations
  config.action_view.raise_on_missing_translations = true

  config.assets.initialize_on_precompile = true
end
