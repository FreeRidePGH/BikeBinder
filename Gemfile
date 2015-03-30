# -*- mode: ruby -*-

source 'https://rubygems.org'

gem 'rails', '4.2.1'

gem 'therubyracer', '~>0.12.1'

gem 'devise', '~>3.4.1'
gem 'cancancan', '~>1.10.1'

gem 'awesome_nested_set', '~>3.0.0.rc.5'
gem 'acts_as_commentable_with_threading', '1.2.0'

# updated hound for rails 4
gem 'hound', '~>0.3.0', :git => 'https://github.com/metaquark/hound', :branch =>'feature/AF-2414_rails4_compat'
gem 'datagrid', '~>0.7.1'

# Modular bulding-blocks for the application
gem 'bike_mfg','>=0.1.12', :git => 'git://github.com/zflat/bike_mfg.git'
gem 'color_name-i18n','>= 0.2', :git => 'git://github.com/zflat/color_name-i18n.git'
gem 'iso_bsd-i18n','>= 0.2', :git => 'git://github.com/zflat/iso_bsd-i18n.git'

# javascript user interface components
gem 'i18n-js'
gem 'select2-rails'
gem 'select2-bikebinder', '>= 0.1.11', :git => 'git://github.com/zflat/select2-bikebinder.git'

# simple paging, filtering for bikes table
gem 'jquery-datatables-rails', '~> 2.2.3'

gem 'friendly_id', '~> 5.0.3'
gem 'decent_exposure', '~>2.2.0'
gem 'squeel', '~>1.2.3'

gem "ruby-units", "~> 1.4.4"

gem 'state_machine', '~>1.2.0', :git => 'https://github.com/seuros/state_machine'

gem 'jquery-ui-rails', '~>5.0.0'
gem 'jquery-ui-themes', '~>0.0.11'
gem 'jquery-rails', '~>2.3.0'

# QR Codes
gem 'rqrcode-rails3',  '~>0.1.7'
gem 'mini_magick', '~>3.8.1'

gem 'sass-rails', "~> 4.0.3"
gem 'coffee-rails', "~> 4.0.1"
gem 'uglifier', ">= 1.3.0"
gem 'bootstrap-sass', '~> 2.3.2.1'
gem "autoprefixer-rails", '~> 3.1.0'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


gem 'rack-ip-whitelist','~>0.0.2', :git => 'git://github.com/zflat/rack-ip-whitelist.git'

group :production do
  # Use PostgreSQL for Heroku deployment
  # gem 'pg'
  # gem 'rails_12factor'
  gem 'rack-protection', '~> 1.5.3'
  gem 'rack-utf8_sanitizer'
end

group :shared_host do
  gem 'fcgi', '~>0.9.2.1'
end

group :shared_host, :production do
  # Use mySQL for hosted deployment
  gem 'mysql2',  '~>0.3.13'
end

gem 'airbrake', '~>4.1.0'

group :test do
  # Pretty printed test output
  gem 'turn', '~>0.9.6', :require => false

  # Testing framework
  gem 'capybara', "~> 2.4.4"
  gem 'poltergeist', "~> 1.5.1"
  gem 'factory_girl_rails', '~>4.5.0'
  
  
  # Speed up testing with spork
  gem 'spork', '~>1.0.0rc4', :git  => 'https://github.com/sporkrb/spork.git'
  gem 'guard-spork', '~>2.1.0'
  gem 'spork-rails', '~>4.0.0'
  
  # System specific for automatic tests on linux
  gem 'rb-inotify', '~> 0.9'
  gem 'libnotify', '0.5.9'
end

group :development do
  gem 'railroady', '~>1'
  gem 'rails-erd', '~>1.1.0'
  gem 'guard-rspec','~>4.5.0', :require=>false
  gem 'spring', '~>1.1.3'

  gem 'capistrano',  '~> 3.2', require: false
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rvm',   '~> 0.1', require: false
end

group :test, :development do
  gem 'rspec-rails', '~>3.1.0'
  gem 'sqlite3', '~>1.3.6'
  gem 'byebug'
end


