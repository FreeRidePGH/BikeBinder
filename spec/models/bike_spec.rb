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

  describe "without a project" do
    before(:each) do
      @bike2 = FactoryGirl.create(:bike)
      @bike2.project = nil
    end
    describe "that is in the shop" do
      it "can not depart" do
        @bike2.should be_shop
        expect{@bike2.depart}.to be{false}
      end
      it "can be assigned to a project" do
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


  describe "A bike with a project" do
    before(:each) do
      @proj = FactoryGirl.create(:youth_project)
      @bike = @proj.bike
    end

    it "is not available" do
      @bike.should_not be_available
    end

    it "can not be assigned a new project" do
      cat = @proj.project_category
      prog = @proj.prog
      
      opts={:bike_id=>@bike,:program_id=>prog}
      new_proj = prog.project_category.project_class.new()
      assigned = new_proj.save if new_proj.assign_to(opts)
      assigned.should == (false || nil)
    end

    describe "that is in the shop" do    

      it "must have an open project" do
        @bike.project.should be_open
      end

      it "must depart when the project closes" do
        @bike.project.close #close on finished project
        @bike.reload
        @bike.should be_departed
      end

      it "must not depart if the project does not close" do
        @bike.project.close #attemp but fail close on unfinished project
        closed = @bike.project.closed?
        @bike.reload
        if closed
          @bike.should be_departed
        else
          @bike.should_not be_departed
        end
      end

      it "can have its project canceled" do
        @proj.should be_can_cancel
      end
      
      it "can have successful delete" do
        expect {@bike.destroy.to change(Bike, :count).by(-1)}
      end
    end
    describe "with a closed project" do
      before(:each) do
        @proj = FactoryGirl.create(:youth_project)
        @bike = @proj.bike
        @proj.close
      end
      it "can't have its project cancelled" do
        @proj.should_not be_can_cancel
      end

      it "must have a closed project" do
        @proj.reload
        @proj.should be_closed
      end

      it "must be departed" do
        @bike.reload
        @bike.should be_departed
      end

      it "can not be deleted" do
        expect {@bike.destroy.to change(Bike, :count).by(0)}
      end
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

