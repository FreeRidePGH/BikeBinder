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

