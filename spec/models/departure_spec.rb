require 'spec_helper'

#Departure
# id | user_id | bike_id | value | method_id | method_type |datetime_departed (would just be created_at)

 #Transaction
 #id | subtotal_value | payment_method_id  | departure_id

 #PayMethod
 #id | name (cash, check, vol credit)

# One nice thing about this is it could allow for a sale to be paid for in a combination of partial cash and partial volunteer credit. At Free Ride, people doing the earn-a-bike sometimes just fix the bike, do some of the required volunteering and then just pay the difference in cash. We also allow as-is purchases to be with volunteer credit or with cash. But we way that fix for sales need to be with cash.

describe Departure do
  before :each do
    @d = FactoryGirl.create(:departure)
  end
  it "with valid arguments should be valid" do
    expect(@d).to be_valid
  end
  
  describe "a new departure" do
    before :each do
      @bike = FactoryGirl.create(:bike)
      @d = Departure.create(:bike=>@bike)
    end

    it "should depart the bike" do
      expect(@bike).to be_departed
    end

    it "should have a departed at" do
      puts @d.created_at.nil?
      expect(@d.departed_at).to_not be_nil
    end

    it "should record the final value" do
      expect(@d.value).to_not be_nil      
    end

    it "should specify the method" do
      expect(@d.method).to_not be_nil      
    end

    describe "for a bike with a hook" do
      before :each do
        @bike = FactoryGirl.create(:bike)
        @hook = FactoryGirl.create(:hook)
        @res = HookReservation.new(:bike => @bike, :hook => @hook)
        expect(@bike.hook).to_not be_nil

        @d = Departure.new(@bike)
      end

      it "should vacate the hook" do
        expect(@bike.hook).to be_nil
      end
    end
  end # describe "a new departure"

  describe "an assigned bike that is departed" do
    before :each do
      @bike = FactoryGirl.create(:bike)
      @program = FactoryGirl.create(:program)
      @assignemnt = Assignment.new(@bike, @program)
      
      @d = Departure.new(@bike)
    end

    it "should specify the assignemnt as the method" do
      expect(@d.method).to_not be_nil      
      expect(@d.method).to eq(@assignment)
    end
  end # describe "an assigned bike that is departed"

  describe "a bike is departed as scrap" do
    before :each do
      @bike = FactoryGirl.create(:bike)
      @program = FactoryGirl.create(:program)
      @scrap = Scrap.new(@bike)

      @d = Departure.new(:bike => @bike, :method =>@scrap)
    end

    it "should specify scrap as the method" do
      expect(@d.method).to_not be_nil
      expect(@d.method).to eq(@scrap)
    end

    it "should have zero value" do
      expect(@d.value).to eq 0
    end
  end # describe "a bike is departed as scrap"
end # describe Departure
