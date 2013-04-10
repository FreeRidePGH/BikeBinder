require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
  #
end

module BikeBinder

  require File.join(File.dirname(__FILE__), "directories.rb")
  
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # setup instructions @ https://github.com/RailsApps/rails3-devise-rspec-cucumber/wiki/Tutorial
    # also see https://www.ruby-forum.com/topic/215482
    # For installing Devise, Ensure you have defined default url options in your environments files. 
    # require 'tlsmail' # http://yekmer.posterous.com/devise-gmail-smtp-configuration
    # Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE) 
    
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
    config.action_mailer.default_url_options= {:host => 'localhost:3000'}
    
    if File.exists?(APP_MAILER_CONFIG_FILE)
      require APP_MAILER_CONFIG_FILE
      config.action_mailer.smtp_settings = MailerConfig::settings
    else
      config.action_mailer.smtp_settings = {
        :enable_starttls_auto => true,
        :port => 587,
        :authentication => :login,
        :address => ENV["BIKE_BINDER_SMTP_ADDRESS"],
        :user_name => ENV["BIKE_BINDER_EMAIL_USER"],
        :password => ENV["BIKE_BINDER_EMAIL_PWD"]
      }
    end


  end
end
