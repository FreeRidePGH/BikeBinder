require 'spec_helper'

describe Project::Eab do
  describe "A new EAB project" do
    it "should be valid" do
      p = FactoryGirl.build(:eab_project)
    end
  end
end
