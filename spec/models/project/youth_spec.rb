require 'spec_helper'

describe Project::Youth do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "Steps" do
    
    it "should have a final state 'done'" do
      
      p = Project::Youth.new()
      final = p.detail.completion_steps.last

      final.should_be :done
      p.detail.done?.sould_be true
      
    end

  end
  
end
