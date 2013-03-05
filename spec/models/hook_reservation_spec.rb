require 'spec_helper'

describe HookReservation do 
  
  describe "a new reservation with given hook and bike" do

    before :each do
      @bike = FactoryGirl.create(:bike)
      @hook = FactoryGirl.create(:hook)
      @r = HookReservation.new(@bike, @hook) 
    end

    it "should be valid" do
      expect(@r).to be_valid
    end

    it "should assign the bike to the hook" do
      expect(@bike.hook).to eq(@hook)
    end

    it "should assign the hook to the bike" do
      expect(@hook.bike).to eq(@bike)
    end
  end # new res with hook and bike


  describe "a new reservation without hook" do 
    before :each do
      @bike = FactoryGirl.create(:bike)
      @r = HookReservation.new(@bik, nil)
    end
    it "should_not be valid" do
      expect(@r).to be_valid
    end
  end # res without a hook

  describe "a new reservation without bike" do 
    before :each do
      @hook = FactoryGirl.create(:hook)
      @r = HookReservation.new(nil, @hook)
    end
    it "should_not be valid" do
      expect(@r).to be_valid
    end
  end # reserve without a hook

  describe "a hook has a conflict or issue" do
    before :each do
      @bike = FactoryGirl.create(:bike)
      @hook = FactoryGirl.create(:hook)
      @r = HookReservation.new(@bike, @hook) 
      @r.hook_raise_issue
    end
    it "should have a state of hook_blocked" do
      expect(@r).to be_hook_unresolved
    end
  end

  describe "a hook becomes unblocked" do
    before :each do
      @bike = FactoryGirl.create(:bike)
      @hook = FactoryGirl.create(:hook)
      @r = HookReservation.new(@bike, @hook)
      @r.hook_resolve
    end
    it "should have a state of hook_resolved" do
      expect(@r).to be_hook_resolved
    end
  end
  
  describe "a bike goes missing" do
    before :each do
      @bike = FactoryGirl.create(:bike)
      @hook = FactoryGirl.create(:hook)
      @r = HookReservation.new(@bike, @hook) 
      @r.bike_lose
    end

    it "should have a state of bike_missing" do
      expect(@r).to be_bike_missing
    end
  end

  describe "a missing bike is found" do
    before :each do
      @bike = FactoryGirl.create(:bike)
      @hook = FactoryGirl.create(:hook)
      @r = HookReservation.new(@bike, @hook) 

      @r.bike_lose
      @r.bike_find
    end

    it "should have a state of bike_present" do
      expect(@r).to be_bike_present
    end
  end

end
