require 'spec_helper'

describe Project::Youth do

  #subject {@detail = 

  before(:each) do
    unless @proj
      @d = FactoryGirl.build(:youth_detail)
      @proj = @d.proj
      @proj.detail = @d
    end
  end

  describe "Steps" do
    
    it "should not have a final state 'done' when first built" do
      d = FactoryGirl.build(:youth_detail)
      final = d.completion_steps.last

      final.should eq(:done)
      d.should_not be_done
    end
  end

  describe "Work Log" do
    
    before(:each) do
      @d = FactoryGirl.build(:youth_detail)
      @user = FactoryGirl.create(:user)

      s = DateTime.now
      e = DateTime.now
      
      @entry_opts = {}
      @entry_opts[:user] = @user
      @entry_opts[:time_start] = s
      @entry_opts[:time_end] = e
      @entry_opts[:description] = "Test entry"
    end

    it "Should have an empty log on creation" do
      @d.work_log.should_not be_nil
      @d.work_log.count.should == 0
    end

    it "should be able to build entry" do
      e = @d.build_work_entry(@entry_opts)
      e.should_not be_nil
    end

    it "should save new entry without errors" do
      e = @d.build_work_entry(@entry_opts)
      e.should_not be_nil
      ret = e.save
      ret.should == true
    end

    it "Should accept new repair entries" do
      lambda do
        t = @d.create_work_entry(@entry_opts)
      end.should change(@d.work_log, :count).by(1)
    end

  end
  
end
