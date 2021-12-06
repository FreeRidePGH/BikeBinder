require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# limited to :test, :development, :production
Bundler.require(*Rails.groups)

module BikeBinder

  require File.join(File.dirname(__FILE__), "directories.rb")
  
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    I18n.enforce_available_locales = true
    
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Configure the default encoding used in templates
    config.encoding = "utf-8"

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

    # Load SMTP from machine-specific configuration file
    # (machine-specific since the file is not stored in git)
    if File.exists?(APP_MAILER_CONFIG_FILE)
      require APP_MAILER_CONFIG_FILE
      config.action_mailer.smtp_settings = MailerConfig::settings
      config.action_mailer.default_url_options= {:host => MailerConfig::default_url_host}
    end
    
    # SMTP settings based on ENV variable
    # ENV variable settings take precedence over config file
    if ENV["BIKE_BINDER_SMTP_ADDRESS"].present?
      config.action_mailer.default_url_options= {:host =>ENV["BIKE_BINDER_URL_HOST"]}
      config.action_mailer.smtp_settings = {
        :enable_starttls_auto => true,
        :port => 587,
        :authentication => :login,
        :address => ENV["BIKE_BINDER_SMTP_ADDRESS"],
        :user_name => ENV["BIKE_BINDER_EMAIL_USER"],
        :password => ENV["BIKE_BINDER_EMAIL_PWD"]
      }
    end

    # White listing IPs
    config.middleware.use( Rack::IpAllowlist, :ips => (ENV['ALLOWLISTED_IPS'] || '*.*.*'))

    # Avoid spoofed IPs in the Rails app
    # http://blog.gingerlime.com/2012/rails-ip-spoofing-vulnerabilities-and-protection#workarounds
    config.middleware.delete ActionDispatch::RemoteIp
  end
end
