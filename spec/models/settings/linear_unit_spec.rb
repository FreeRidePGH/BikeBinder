require 'rails_helper'
require 'settings'

module Settings

  RSpec.describe LinearUnit, :type=>:model do

    it "should have a persistance unit that is a unit" do
      expect(LinearUnit.persistance.units).to_not be_nil
    end

    it "should have a display unit based on the user" do
      
    end

    it "should have a default unit for display" do
      
    end

    it "should have a default unit for input" do
      
    end

    it "should have a unit for input based on the user" do

    end

  end

end # module Settings
