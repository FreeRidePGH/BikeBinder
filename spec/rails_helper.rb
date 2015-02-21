# Check if spec_helper is being loaded multiple times and from where
if $LOADED_FEATURES.grep(/spec\/rails_helper\.rb/).any?
   begin
     raise "foo"
   rescue => e
     puts <<-MSG
   ===================================================
   It looks like rails_helper.rb has been loaded
   multiple times. Normalize the require to:

     require "spec/rails_helper"

   Things like File.join and File.expand_path will
   cause it to be loaded multiple times.

   Loaded this time from:

     #{e.backtrace.join("\n    ")}
   ===================================================
     MSG
   end
end

require 'spec_helper'

 RSpec.configure {|c| c.raise_errors_for_deprecations!}
