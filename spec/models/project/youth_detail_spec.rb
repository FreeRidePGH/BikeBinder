require 'spec_helper'

describe Project::Youth do

  #subject {@detail = 

  describe "Steps" do
    
    it "should not have a final state 'done' when first built" do
      d = FactoryGirl.build(:youth_detail)
      final = d.completion_steps.last

      final.should eq(:done)
      d.should_not be_done
    end

  end
  
end
