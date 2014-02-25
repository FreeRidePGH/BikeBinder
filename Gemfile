source 'https://rubygems.org'

ruby "2.0.0"

gem 'rails', '4.0.0'

gem 'protected_attributes'

gem 'therubyracer', '~>0.11.4'

gem 'devise', '~>3.0.0'
gem 'cancan', '~>1.6.10'

gem 'acts_as_commentable_with_threading', '1.1.2', :github => 'D1plo1d/acts_as_commentable_with_threading', :branch => 'patch-1'
#elight/acts_as_commentable_with_threading'

gem 'hound', '~>0.3.0'
gem 'datagrid', '~>0.7.1'

# Modular bulding-blocks for the application
gem 'bike_mfg','>=0.1.8', :git => 'git://github.com/zflat/bike_mfg.git'
gem 'color_name-i18n','>= 0.2', :git => 'git://github.com/zflat/color_name-i18n.git'
gem 'iso_bsd-i18n','>= 0.2', :git => 'git://github.com/zflat/iso_bsd-i18n.git'

# javascript user interface components
gem 'i18n-js'
gem 'select2-rails'
gem 'select2-bikebinder', '>= 0.1.11', :git => 'git://github.com/zflat/select2-bikebinder.git'

# simple paging, filtering for bikes table
gem 'jquery-datatables-rails'


gem 'friendly_id', :github => 'FriendlyId/friendly_id'
gem 'decent_exposure', '~>2.2.0'
gem 'squeel', '~>1.1.0'

gem "ruby-units", "~> 1.4.4"

gem 'state_machine', '~>1.2.0'
gem 'ruby-graphviz', :require => 'graphviz'

gem 'jquery-ui-rails'
gem 'jquery-ui-themes'

# QR Codes
gem 'rqrcode-rails3'
gem 'mini_magick'

gem 'sass-rails', "~> 4.0.0"
gem 'coffee-rails', "~> 4.0.0"
gem 'uglifier', ">= 1.3.0"
gem 'bootstrap-sass', '~> 2.3.2.1'

gem 'jquery-rails', '~>2'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :production do
  # Use PostgreSQL for Heroku deployment
  # gem 'pg'
  gem 'rails_12factor'
end

group :shared_host do
  # Use mySQL for hosted deployment
  gem 'mysql2',  '~>0.3.13'
  gem 'fcgi'
end

group :test do
  gem 'sqlite3', '~>1.3.6'

  # Pretty printed test output
  gem 'turn', :require => false

  # Testing framework
  gem 'rspec-rails', '~>2'
  gem 'capybara', "~> 2.1.0"
  gem 'poltergeist', "~> 1.3.0"
  gem 'factory_girl_rails', '~>4.2.1'
  
  
  # Speed up testing with spork
  gem 'guard-spork', '~>1.5.1'
  gem 'spork-rails', :git => 'git://github.com/sporkrb/spork-rails.git'
  
  # System specific for automatic tests on linux
  gem 'rb-inotify', '~> 0.9'
  gem 'libnotify', '0.5.9'
end

group :development do
  gem 'sqlite3', '~>1.3.6'
  gem 'railroady', '~>1'
  gem 'rails-erd'
  gem 'rspec-rails', '~>2'
  gem 'guard-rspec', '0.5.5'
end


