require 'spec_helper'

describe Bike do

  describe "url slugging" do
    
    before :each do
      @bike = FactoryGirl.create(:bike)
      @slug = @bike.slug
    end
    
    it "should be able to extract number from slug" do
      n = Bike.number_from_slug(@slug)
      expect(n).to_not be_nil
      expect(n).to eq @bike.number.to_s
    end

    describe "a valid bike" do

      it "should have a slug" do
        expect(@slug).to_not be_nil
      end

      it "should be able to find by slug" do
        expect(Bike.find_by_slug(@slug)).to eq @bike
      end
    end      
  end

  describe "A new bike" do
    before :each do
      @brand = FactoryGirl.create(:bike_brand)
      @model = FactoryGirl.create(:bike_model)
      @bike = FactoryGirl.create(:bike)
    end

    it "Should be valid" do
      @bike.save
      @bike.errors.count.should == 0
    end

    it "Should have a model" do
      puts @bike.bike_model
      expect(@bike.model).to_not be_nil
    end

    describe "Seat tube height" do
      
      it "should accept units" do
        height = Unit.new('1 mm')
        @bike.seat_tube_height = height
        
        expect(@bike.seat_tube_height).to eq height
      end

      it "should have the correct persistance units" do
        expect(@bike.seat_tube_height.units).to eq Settings::LinearUnit.persistance.units
      end

      it "should have units" do
        expect(@bike.seat_tube_height.respond_to?(:units)).to be_true
      end

    end

    describe "with invalid number" do
      it "should not be valid" do
        @bike.number = '123456'
        is_valid = @bike.valid?
        expect(@bike.errors.count).to_not eq 0
        expect(@bike.errors.count>0).to be_true
        expect(is_valid).to be_false
      end
    end

  end # describe a new Bike

  describe "that is deleted" do
    before(:each) do
      @bike = FactoryGirl.create(:bike)
      @b_id = @bike.id
      @bike.destroy
    end
    
    it "should not have any errors" do
      @bike.errors.count.should == 0
    end
    
    it "should not be found" do
      Bike.find_by_id(@b_id).should be_nil
    end

    describe "its serial number" do
      it "the S/N object should not be edited"
    end
  end

  describe "without an assignment" do
    before(:each) do
      @bike2 = FactoryGirl.create(:bike)
    end
    describe "that is in the shop" do
      it "can not depart" do
        @bike2.should be_shop
        expect{@bike2.depart}.to be{false}
      end
      it "can be assigned" do
        @bike2.should be_available
      end
    end
  end

  describe "When the bike number is changed" do
    before(:each) do
      @bike = FactoryGirl.create(:bike)
      @new_number = BikeNumber.format_number(10000+Bike.count+1)
    end

    it "is allowed" do
      @bike.number = @new_number
      expect(@bike).to be_valid
    end

    it "should not delete S/N record"
    it "should remove association with prev. S/N record"
    
  end


  describe "A bike with an assignment" do
    before (:each) do
      @bike = FactoryGirl.create(:bike)
    end


    it "is not available"

    it "can not be assigned"

    describe "that is canceled" do

      it "should be available" 

      it "should have a record of the canceled assignment"

      it "should have an association with the canceled assignment"

      it "should not have an active assignment"
      
    end
    
    describe "that is in the shop" do    

      it "can have successful delete" do
        expect {@bike.destroy.to change(Bike, :count).by(-1)}
      end
    end

  end

end


