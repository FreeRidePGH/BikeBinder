require 'spec_helper'

describe Hook do

  describe "A new hook" do
    it "should be found by label" do
      @hook = FactoryGirl.create(:hook)
      @hook2 = FactoryGirl.create(:hook)
      label = @hook.label
      
      found = Hook.find_by_label(label)
      found.should == @hook
    end
  end

end



# == Schema Information
#
# Table name: hooks
#
#  id         :integer         not null, primary key
#  number     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  bike_id    :integer
#

