require 'spec_helper'

describe Project::EabDetail do

  #subject {@detail = 

  describe "Steps" do
    it "should have an event 'finish'" do
      Project::EabDetail.state_machine.events.keys.include?(:finish).should == true
    end
    
    it "should not have a final state 'done' when first built" do
      d = FactoryGirl.build(:eab_detail)
      final = d.completion_steps.last

      final.should eq(:done)
      d.should_not be_done
    end

    it "should have an inspected state" do
      d = FactoryGirl.build(:eab_detail)
      steps = d.completion_steps
      
      steps.should_not be_nil

      steps.include?(:inspected).should == true
      steps.include?(:ready_to_inspect).should == true

    end

  end
  
end
