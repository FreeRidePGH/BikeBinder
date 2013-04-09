source 'https://rubygems.org'

gem 'rails', '3.2.12'
gem 'strong_parameters'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


gem 'therubyracer', '~>0.10.1'

gem 'devise', '~>2.1.0'
gem 'cancan', '~>1.6.9'
gem 'acts_as_commentable_with_threading', '1.1.2'
gem 'hound', '~>0.3.0'
gem 'datagrid', '~>0.7.1'

# Modular bulding-blocks for the application
gem 'bike_mfg','>=0.1.4', :git => 'git://github.com/zflat/bike_mfg.git'
gem 'color_name-i18n','>= 0.2', :git => 'git://github.com/zflat/color_name-i18n.git'
gem 'iso_bsd-i18n','>= 0.2', :git => 'git://github.com/zflat/iso_bsd-i18n.git'

# javascript user interface components
gem 'i18n-js'
gem 'select2-rails'
gem 'select2-bikebinder', '>= 0.1.10', :git => 'git://github.com/zflat/select2-bikebinder.git'
# simple paging, filtering for bikes table
gem 'jquery-datatables-rails'


gem 'friendly_id', '~>4.0.5'
gem 'decent_exposure', '~>1.0.2'
gem 'squeel', '~>1.0.14'

gem "ruby-units", "~> 1.4.2"

gem 'state_machine', '~>1.1.2'
gem 'ruby-graphviz', :require => 'graphviz'

gem 'surveyor', '~>0.22.0'

gem 'jquery-ui-rails'
gem 'jquery-ui-themes'

# QR Codes
gem 'rqrcode-rails3'
gem 'mini_magick'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', ">= 1.0.3"
  gem 'bootstrap-sass', '~> 2.3.1.0'
end

gem 'jquery-rails', '~>2'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :production do
  # Use PostgreSQL for Heroku deployment
  gem 'pg'
end

group :test do
  gem 'sqlite3', '~>1.3.6'

  # Pretty printed test output
  gem 'turn', :require => false

  # Testing framework
  gem 'rspec-rails', '~>2'
  gem 'capybara', "~> 2.0.2"
  gem 'poltergeist', "~> 1.1.0"
  gem 'factory_girl_rails', '~>4.0'
  
  
  # Speed up testing with spork
  gem 'guard-spork', '0.3.2'
  gem 'spork', '0.9.0'
  
  # System specific for automatic tests on linux
  gem 'rb-inotify', '0.8.8'
  gem 'libnotify', '0.5.9'
end

group :development do
  gem 'sqlite3', '~>1.3.6'
  gem 'railroady', '~>1'
  gem 'rails-erd'
  gem 'rspec-rails', '~>2'
  gem 'guard-rspec', '0.5.5'
  gem 'tlsmail'
end

gem 'heroku'
