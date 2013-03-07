require 'spec_helper'

describe HookReservation do 
  
  describe "created with given hook and bike" do

    before :each do
      @bike = FactoryGirl.create(:bike)
      @hook = FactoryGirl.create(:hook)
      
      #@r = FactoryGirl.create(:hook_reservation)
      @r = HookReservation.create(:bike_id => @bike.id, :hook_id => @hook.id)
    end

    it "should be valid" do
      expect(@r).to be_valid
    end

    it "should reference the bike" do
      expect(@r.bike).to eq @bike
    end

    it "should reference the hook" do
      expect(@r.hook).to eq @hook
    end

    it "should assign the bike to the hook" do
      expect(@bike.hook_reservation).to_not be_nil
      expect(@bike.hook_reservation).to eq @r
      expect(@bike.hook).to eq(@hook)
    end

    it "should assign the hook to the bike" do
      expect(@hook.reservation).to eq (@r)
      expect(@hook.bike).to eq(@bike)
    end

    describe "bike_sate" do
      it "should be present" do
        expect(@r).to be_bike_present
      end
    end
    describe "hook_sate" do
      it "should be resolved" do
        expect(@r).to be_hook_resolved
      end
    end
  end # created with hook and bike

  describe "a new reservation without hook" do 
    before :each do
      @r = FactoryGirl.create(:hook_reservation)
    end
    it "should_not be valid" do
      expect(@r).to be_valid
    end
  end # res without a hook

  describe "a new reservation without bike" do 
    before :each do
      @hook = FactoryGirl.create(:hook)
      @r = HookReservation.new(:bike_id => nil, :hook_id => @hook.id)
    end
    it "should_not be valid" do
      expect(@r).to_not be_valid
    end
  end # reserve without a hook

  describe "a hook has a conflict or issue" do
    before :each do
      @bike = FactoryGirl.create(:bike)
      @hook = FactoryGirl.create(:hook)
      @r = HookReservation.new(:bike_id => @bike.id, :hook_id => @hook.id) 
      @r.raise_issue_hook
    end
    it "should have a state of hook_blocked" do
      expect(@r).to be_hook_unresolved
    end
  end

  describe "a hook becomes unblocked" do
    before :each do
      @r = FactoryGirl.create(:hook_reservation)
      @r.resolve_hook
    end
    it "should have a state of hook_resolved" do
      expect(@r).to be_hook_resolved
    end
  end
  
  describe "a bike goes missing" do
    before :each do
      @r = FactoryGirl.create(:hook_reservation)
      @r.lose_bike
    end

    it "should have a state of bike_missing" do
      expect(@r).to be_bike_missing
    end
  end

  describe "a missing bike is found" do
    before :each do
      @r = FactoryGirl.create(:hook_reservation)
      @r.lose_bike
      @r.find_bike
    end

    it "should have a state of bike_present" do
      expect(@r).to be_bike_present
    end
  end

end
