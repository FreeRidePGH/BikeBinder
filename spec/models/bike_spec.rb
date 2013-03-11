require 'spec_helper'

describe Bike do
  subject(:bike){FactoryGirl.create(:bike)}

  describe "url slugging" do
    let(:slug){bike.slug}
    
    it "can extract number from slug" do
      n = Bike.number_from_slug(slug)
      expect(n).to_not be_nil
      expect(n).to eq bike.number.to_s
    end

    describe "a valid bike" do
      it "has a slug" do
        expect(slug).to_not be_nil
      end

      it "is found by slug" do
        expect(Bike.find_by_slug(slug)).to eq bike
      end
    end      
  end

  describe "#number" do
    subject(:next_bike){Bike.new(:number => bike.number)}
    it "can not be re-used" do
      expect(next_bike).to_not be_valid
    end
  end

  describe "#model" do
    let(:model){FactoryGirl.create(:bike_model)}
    before :each do
      bike.bike_model = model
    end
    it "is assigned" do
      expect(bike.model).to_not be_nil
      expect(bike.model).to eq model
    end
  end

  describe "Seat tube height" do
    let(:height){Unit.new('1 mm')}
    
    before :each do
      bike.seat_tube_height = height
    end
    
    it "accepts units" do
      expect(bike.seat_tube_height).to eq height
    end
    
    it "should have the correct persistance units" do
      expect(bike.seat_tube_height.units).to eq Settings::LinearUnit.persistance.units
    end
    
    it "should have units" do
      expect(bike.seat_tube_height.respond_to?(:units)).to be_true
    end
    
  end
  
  context "with invalid number" do
    let(:number){'123456'} 
    subject(:bike_bad_num) do
      b = FactoryGirl.build(:bike)
      b.number = number
      b
    end

    it "should not be valid" do
      is_valid = bike_bad_num.valid?
      expect(bike_bad_num.errors.count).to_not eq 0
      expect(bike_bad_num.errors.count>0).to be_true
      expect(is_valid).to be_false
    end
  end

  context "with a hook" do
    let(:reservation){FactoryGirl.create(:hook_reservation)}
    subject(:bike){reservation.bike}

    it "is valid" do
      expect(bike).to be_valid
    end
  end

  context "is deleted" do
    subject(:bike){FactoryGirl.create(:bike)}
    let(:b_id){bike.id}
    let(:b_sn){bike.id}
    before(:each) do
      bike.destroy
    end
    
    it "can not have any errors" do
      bike.errors.count.should == 0
    end
    
    it "can not be found" do
      Bike.find_by_id(b_id).should be_nil
    end

    describe "# serial number" do
      subject(:next_bike){Bike.new(:number => b_sn)}
      it "can be re-used" do
        expect(next_bike).to be_valid
      end
    end
  end

  context "without an assignment" do
    subject(:bike_not_asgnd){FactoryGirl.create(:bike)}

    describe "that is in the shop" do
      it "can not depart"
      it "can be assigned"
    end
  end

  context "the bike number is changed" do
    before(:each) do
      @bike = FactoryGirl.create(:bike)
      @new_number = BikeNumber.format_number(10000+Bike.count+1)
    end

    it "is allowed" do
      @bike.number = @new_number
      expect(@bike).to be_valid
    end
  end


  context "with an assignment" do
    before (:each) do
      @bike = FactoryGirl.create(:bike)
    end

    it "is not available"

    it "can not be assigned"

    context "which is canceled" do

      it "is be available" 

      it "has no assignment"

      it "has a record of the canceled assignment"
      
    end
    
    context "in the shop" do    

      it "can be deleted" do
        expect {@bike.destroy.to change(Bike, :count).by(-1)}
      end

    end

  end

end


