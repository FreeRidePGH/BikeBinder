require 'spec_helper'

describe Project do

  describe "Actions" do
    it "should have a 'close' method" do
      p = FactoryGirl.build(:youth_project)
      p.respond_to?(:close).should == true
    end
  end

  describe "A closed project" do
    it "should have a departed bike" do
      p = FactoryGirl.build(:youth_project)
      p.close.should == true
      p.bike.should be_departed
    end
  end

  describe "A project without a bike" do
    it "should not be allowed to save" do
      p = FactoryGirl.build(:youth_project)
      p.bike = nil
      result = p.save
      result.should == false
    end

    it "should have close action, but should not be allowed to close" do
      p = FactoryGirl.build(:youth_project)
      p.bike = nil

      p.respond_to?(:close).should == true

      result = p.close
      result.should == false
    end
  end

  describe "A project that gets canceled" do
    before(:each) do
      @proj = FactoryGirl.create(:youth_project)
      @b_id = @proj.bike.id
      @proj.cancel
    end
    it "should be marked as trash" do
      @proj.should be_trash
    end

    it "should null the bike association" do
      Bike.find_by_id(@b_id).project.should be_nil
    end

    it "should not delete the bike record" do
      Bike.find_by_id(@b_id).should_not be_nil
    end
  end
end
# == Schema Information
#
# Table name: projects
#
#  id                  :integer         not null, primary key
#  type                :string(255)
#  prog_id             :integer
#  prog_type           :string(255)
#  label               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  closed_at           :datetime
#  project_category_id :integer
#  state               :string(255)
#  completion_state    :string(255)
#

