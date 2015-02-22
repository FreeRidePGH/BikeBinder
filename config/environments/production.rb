Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  config.active_record.migration_error = :page_load

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to pug simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this
  # For large-scale produciton use, consider using a caching reverse proxy like
  # NGINX, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static files from the '/public' folder by default since
  # Apache or NGINX already handle this
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  
  # Compress JavaScripts and CSS
  #config.assets.js_compressor = :uglifier
  if false
    config.assets.js_compressor = Uglifier.new(:mangle => false, 
                                               :output => {
                                                 :ascii_only => true}
                                               )
  end
  config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Do fallback to assets pipeline if a precompiled asset is missed
  if ENV['PRECOMPILE']=='true'
    config.assets.compile = true
  end

  # Generate digests for assets URLs
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb in rails 4.2

  # Initialize the application in order to compile assets (like js-i18n)
  config.assets.initialize_on_precompile = true

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # See everything in the log to ensure availability of diagnostic information
  # when problems arise
  config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Prepend all log lines with the following tags.
  # config.log_tags = [:subdomain, :uuid]

  # Use a different logger for distributed setups
  # config.logger = AciveSupport::TaggedLogging.new(SysLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default loggin formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
