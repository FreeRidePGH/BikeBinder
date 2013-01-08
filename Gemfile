source 'http://rubygems.org'

gem 'rails', '3.2.0'
gem 'strong_parameters'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


gem 'therubyracer', '~>0.10.1'

gem 'devise', '~>2.1.0'
gem 'acts_as_commentable_with_threading', '1.1.2'

# Modular bulding-blocks for the application
gem 'bike_mfg', :path => '/home/william/rails_projects/bike_mfg'
# gem 'bike_mfg', :git => 'git://github.com/zflat/bike_mfg.git'
gem 'color_name-i18n', 
    :path => '/home/william/rails_projects/color_name-i18n'
#gem 'color_name-i18n', :git => 'git://github.com/zflat/color_name-i18n.git'
gem 'iso_bsd-i18n', :git => 'git://github.com/zflat/iso_bsd-i18n.git'
gem 'time_sheet', :git => 'git://github.com/zflat/time_sheet.git'

gem 'i18n-js'
gem 'select2-rails'

gem 'select2-bikebinder', 
:path =>'/home/william/rails_projects/select2-bikebinder'
#gem 'select2-bikebinder', '>= 0.1.1', :git => 'git://github.com/zflat/select2-bikebinder.git', :group => :production


gem 'rack-cors', :require => 'rack/cors'
gem 'friendly_id', '~>4.0.5'
gem 'decent_exposure', '~>1.0.2'
gem 'squeel', '~>1.0.14'

gem 'state_machine', '1.1.2'
gem 'ruby-graphviz','~>1.0.5', :require => 'graphviz'

gem 'paper_trail', '~>2'

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

  # Include faker gem so that db:populate will work in the heroku deployment
  gem 'faker', '~>1'
end

#require 'rubyXL'

group :test do
  gem 'sqlite3', '~>1.3.6'

  # Pretty printed test output
  gem 'turn', :require => false
  gem 'rspec-rails', '~>2'
  gem 'capybara'

  gem 'factory_girl_rails', '3.0'
  
  # Speed up testing with spork
  gem 'guard-spork', '0.3.2'
  gem 'spork', '0.9.0'
  
  # System specific for automatic tests on linux
  gem 'rb-inotify', '0.8.8'
  gem 'libnotify', '0.5.9'
end

group :development do
  gem 'sqlite3', '~>1.3.6'
  #gem 'annotate', '~> 2.4.1.beta'
  gem 'faker', '~>1'
  gem 'railroady', '~>1'
  gem 'rspec-rails', '~>2'
  gem 'guard-rspec', '0.5.5'
  gem 'nokogiri'
  gem 'rubyXL'

end
