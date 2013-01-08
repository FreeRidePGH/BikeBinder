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

  describe "that is deleted" do
    before(:each) do
      @proj_detail = FactoryGirl.create(:youth_detail)
      @proj = @proj_detail.proj
      @p_id = @proj.id
      @pdet_id = @proj.detail.id
      @bike = @proj.bike
      @b_id = @bike.id
      @bike.destroy
    end
    
    it "should not have any errors" do
      @bike.errors.count.should == 0
    end
    
    it "should not be found" do
      Bike.find_by_id(@b_id).should be_nil
    end

    describe "with a project" do
      describe ", the project" do
        it "should be deleted" do
          Project.find_by_id(@p_id).should be_nil
        end
      end

      describe ", the project details" do
        it "should be deleted" do
          Project::YouthDetail.find_by_id(@pdet_id).should be_nil
        end
      end
    end

    describe "its serial number" do
      it "the S/N object should not be edited"
    end
  end

  describe "without an assignment" do
    before(:each) do
      @bike2 = FactoryGirl.create(:bike)
      @bike2.project = nil
    end
    describe "that is in the shop" do
      it "can not depart" do
        @bike2.should be_shop
        expect{@bike2.depart}.to be{false}
      end
      it "can be assigned" do
        @bike2.should be_available
      end
    end
  end

  describe "When the bike number is changed" do
    before(:each) do
      @bike = FactoryGirl.create(:bike)
    end
    it "is allowed" do
      @bike.number = (@bike.number.to_i+2000).to_s
      @bike.save
      @bike.errors.count.should == 0
    end

    it "should not delete S/N record"
    it "should remove association with prev. S/N record"
    
  end


  describe "A bike with an assignment" do
    before (:each) do
      @bike = FactoryGirl.create(:bike)
    end


    it "is not available"

    it "can not be assigned"

    describe "that is canceled" do

      it "should be available" 

      it "should have a record of the canceled assignment"

      it "should have an association with the canceled assignment"

      it "should not have an active assignment"
      
    end
    
    describe "that is in the shop" do    

      it "must have an open project"


      it "must depart when the project closes"

      it "must not depart if the project does not close"

      it "can have its project canceled"
      
      it "can have successful delete" do
        expect {@bike.destroy.to change(Bike, :count).by(-1)}
      end
    end

    describe "with a closed project" do

      it "can't have its project cancelled"

      it "must have a closed project" 

      it "must be departed"

      it "can not be deleted" do
        expect {@bike.destroy.to change(Bike, :count).by(0)}
      end
    end
  end


end


