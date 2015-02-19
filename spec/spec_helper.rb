# Check if spec_helper is being loaded multiple times and from where
if $LOADED_FEATURES.grep(/spec\/spec_helper\.rb/).any?
   begin
     raise "foo"
   rescue => e
     puts <<-MSG
   ===================================================
   It looks like spec_helper.rb has been loaded
   multiple times. Normalize the require to:

     require "spec/spec_helper"

   Things like File.join and File.expand_path will
   cause it to be loaded multiple times.

   Loaded this time from:

     #{e.backtrace.join("\n    ")}
   ===================================================
     MSG
   end
end


require 'rubygems'
require 'spork'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do

  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.


  # NOTE: Additions from the ruby on rails tutorial book

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  # require 'rspec/autorun'

  require 'capybara/rspec'
  require 'capybara/rails'
  require 'capybara/poltergeist'
  require 'devise'


  ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

  SPEC_TEMP_PATH = File.join(File.dirname(__FILE__), 'tmp')

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, :debug => false)
  end
  Capybara.javascript_driver = :poltergeist

  # Solution to 'spork does not load helper methods'
  # http://stackoverflow.com/questions/10217755/rails-3-2-3-with-spork-does-not-recognize-helper-methods-in-cucumber-tests
  view_helpers = Dir["#{Rails.root}/app/helpers/*.rb"]
  view_helpers.collect do |full_name|
    include Object.const_get(File.basename(full_name,'.rb').camelize)
  end
  
  RSpec.configure do |config|
    
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # Make it so poltergeist (out of thread) tests can work with transactional fixtures
    # http://www.opinionatedprogrammer.com/2011/02/capybara-and-selenium-with-rspec-and-rails-3/#post-441060846
    # http://stackoverflow.com/questions/9984113/rspeccapybara-request-specs-w-js-not-working
    # http://stackoverflow.com/a/15256111/2220169
    ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
      def current_connection_id
        Thread.main.object_id
      end
    end

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    config.infer_spec_type_from_file_location!
    # config.raise_errors_for_deprecations!

    config.include Devise::TestHelpers, :type => :controller
  end

end

Spork.each_run do
  # This code will be run each time you run your specs.

end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.

