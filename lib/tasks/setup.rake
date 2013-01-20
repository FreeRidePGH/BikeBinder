desc "Setup/installation script to run after the first clone"
task :setup => :environment do

  puts `bundle install`

  require File.dirname(__FILE__) + "/../../config/directories.rb"
  require 'fileutils'
  # Database config file
  if !File.exists?(APP_DB_CONIG_FILE)
    puts `cp config/database.yml.sample config/database.yml`
  end

  # Create the secret token
  Rake::Task['create_a_secret'].invoke
  
  # Create the db, load schema and seed
  Rake::Task['db:setup'].invoke

end

namespace :db do
  
  desc "Prepare test database structure"
  task :test_setup => :environment do

    # Preparte test db
    # http://stackoverflow.com/questions/5264355/rspec-failure-could-not-find-table-after-migration
    # http://guides.rubyonrails.org/testing.html#preparing-your-application-for-testing

    Rake::Task['db:test:clone_structure'].invoke

    ENV['FILE'] = 'surveys/bike_overhaul_inspection.rb'    
    ENV['RAILS_ENV'] = 'test'
    Rake::Task['surveyor'].invoke
  end

end
