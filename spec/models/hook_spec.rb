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

  describe "Hooks with an assigned bike" do

    before(:each) do
      @hook = FactoryGirl.create(:hook)
      @bike = FactoryGirl.create(:bike)
      @bike.reserve_hook!(@hook)      
    end

    it "should not be available" do
      @hook.bike.should_not be_nil
    end

    it "should reference the correct bike" do
      @hook.reload
      @hook.bike.should == @bike
    end

  end


  describe "Hooks without an assigned bike" do

    before(:each) do
      @hook = FactoryGirl.create(:hook)
    end

    it "should not reference a bike" do
      @hook.bike.should be_nil
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

