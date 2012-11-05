source 'http://rubygems.org'

gem 'rails', '3.2.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


gem 'therubyracer', '~>0.10.1'

gem 'devise', '~>2.1.0'
gem 'acts_as_commentable_with_threading', '1.1.2'
gem 'time_sheet', :git => 'git://github.com/zflat/time_sheet.git'

gem 'friendly_id', '~>4.0.5'
gem 'decent_exposure', '~>1.0.2'
gem 'squeel', '~>1.0.1'

gem 'state_machine', '1.1.2'
gem 'ruby-graphviz','~>1.0.5', :require => 'graphviz'

gem 'paper_trail', '~>2'

gem 'surveyor', '~>0.22.0'

gem 'nokogiri'
gem 'rubyXL'
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
end
