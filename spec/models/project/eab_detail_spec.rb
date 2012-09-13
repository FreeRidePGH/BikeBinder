require 'spec_helper'

describe Project::EabDetail do

  #subject {@detail = 

  describe "Steps" do
    it "should have an event 'finish_project'" do
      Project::EabDetail.state_machine.events.keys.include?(:finish_project).should == true
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
# == Schema Information
#
# Table name: project_eab_details
#
#  id                     :integer         not null, primary key
#  proj_id                :integer
#  proj_type              :string(255)
#  state                  :string(255)
#  status_state           :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  inspection_access_code :string(255)
#

