require 'spec_helper'


describe Bike do

  describe "A new bike" do

    it "Should be valid" do
      @bike = FactoryGirl.create(:bike)
      @bike.save
      @bike.errors.count.should == 0
    end

    describe "Assigning a hook" do

      it "should be assigned to an available hook" do
        @bike = FactoryGirl.create(:bike)
        @bike.should be_can_reserve_hook

        @hook = FactoryGirl.create(:hook)
        @hook.should_not be_nil

        @bike.reserve_hook!(@hook)

        @bike.should_not be_can_reserve_hook
        @bike.hook.should_not be_nil
      end

    end

  end

  describe "When a bike is deleted" do
    describe "and it has a project" do
      describe "the proejct" do
        it "should be deleted"
      end

      describe "the project details" do
        it "should be deleted"
      end
    end

    describe "its serial number" do
      it "the S/N object should not be edited"
    end
  end

  describe "A bike without a project" do

    describe "a bike in the shop" do
      it "can not depart"
      
      it "can be assigned to a project"
    end

  end

  describe "When the bike number is changed" do
    it "is allowed" 

    it "should not delete S/N record"

    it "should remove association with prev. S/N record"
    
  end


  describe "A bike with a project" do
    it "can not be assigned a new project"
    describe "that is in the shop" do    
      it "must depart when the project closes"

      it "must not depart if the project does not close"

      it "must have an open project"

      it "can have its project canceled"
      
      it "can be deleted"
    end
    describe "that is not in the shop" do
      it "can't have its project cancelled"

      it "must have a closed project"

      it "can not be deleted"
    end
  end



end


# == Schema Information
#
# Table name: bikes
#
#  id               :integer         not null, primary key
#  color            :string(255)
#  value            :float
#  seat_tube_height :float
#  top_tube_length  :float
#  created_at       :datetime
#  updated_at       :datetime
#  departed_at      :datetime
#  mfg              :string(255)
#  model            :string(255)
#  number           :string(255)
#  project_id       :integer
#  location_state   :string(255)
#

