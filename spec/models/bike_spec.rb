require 'rails_helper'

RSpec.describe Bike, :type=>:model do
  subject(:bike){FactoryGirl.create(:bike)}

  context "with number and color" do
    it "is valid" do
      expect(bike).to be_valid
    end
  end

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
  end # describe "url slugging"

  describe "#number" do
    let(:number_param) do
      ActionController::Parameters.new({:number_record => bike.number}).permit(:record_number)
    end
    subject(:next_bike){Bike.new(number_param)}
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

    context "with brand" do
      let(:brand_model){FactoryGirl.create(:bike_model_with_brand)}
      let(:brand){brand_model.brand}
      
      before :each do
        bike.bike_model = brand_model
      end
      it "is assigned" do
        expect(bike.model).to_not be_nil
        expect(bike.model).to eq brand_model
      end

      it "associates the bike to the the brand" do
        expect(bike.brand).to eq brand
      end
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
      expect(bike.seat_tube_height.respond_to?(:units)).to be_truthy
    end
    
  end

context "with a non-number seat-tube height" do
    let(:non_number){'abc'}
    subject(:bike){Bike.new(:seat_tube_height => non_number)}
    let(:measurement){55}
    describe "assigning a numberical measurement" do
      before :each do
        bike.seat_tube_height = measurement
      end
      it "overrides the old value" do
        expect(bike.seat_tube_height).to_not eq non_number
      end

      it "records the measurement" do
        expect(bike.seat_tube_height.scalar).to eq measurement
      end

    end # describe "assigning a numberical measurement"
  end # context "with a non-number seat-tube height"

  context "with a non-number top-tube length" do
    let(:non_number){'abc'}
    subject(:bike){Bike.new(:top_tube_length => non_number)}
    let(:measurement){55}
    describe "assigning a numberical measurement" do
      before :each do
        bike.top_tube_length = measurement
      end
      it "overrides the old value" do
        expect(bike.top_tube_length).to_not eq non_number
      end

      it "records the measurement" do
        expect(bike.top_tube_length.scalar).to eq measurement
      end
    end # describe "assigning a numberical measurement"
  end # context "with a non-number top-tube"
  
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
      expect(bike_bad_num.errors.count>0).to be_truthy
      expect(is_valid).to be_falsey
    end
  end

  context "with a hook" do
    let(:reservation){FactoryGirl.create(:hook_reservation)}
    subject(:bike){reservation.bike}

    it "is valid" do
      expect(bike).to be_valid
    end
  end

  context "is destroyed" do
    subject(:bike){FactoryGirl.create(:bike)}
    let(:b_id){bike.id}
    let!(:b_sn){bike.number}

    before(:each) do
      bike.destroy
    end
    
    it "can not have any errors" do
      expect(bike.errors.count).to eq 0
    end
    
    it "can not be found" do
      expect(Bike.find_by_id(b_id)).to be_nil
    end

    describe "# serial number" do
      let(:bike_param) do
        ActionController::Parameters.new({
                                           :number_record => bike.number_record,
                                           :color => 'FFFFFF'
                                         }).
          permit(:number_record, :color)
      end
      let!(:next_bike){Bike.new(bike_param)}

      before(:each) do
        next_bike
        bike.destroy
      end

      it "can be re-used" do
        expect(next_bike).to be_valid
      end
    end
  end

  context "without an assignment" do
    subject(:bike_not_asgnd){FactoryGirl.create(:bike)}

    context "that is in the shop" do
      describe "departs" do
        let(:departure){Departure.build(:bike => bike_not_asgnd, :value => 0)}

        before :each do
          departure.save
          bike_not_asgnd.reload
        end
        
        it "has invalid departure" do
          expect(departure).to_not be_valid
        end

        it "is not departed" do
          expect(bike_not_asgnd).to_not be_departed
        end
      end
      
      describe "is assigned to a program" do
        let(:program){FactoryGirl.create(:program)}
        let(:assignment){Assignment.build(:bike => bike_not_asgnd, :program => program)}

        before :each do
          assignment.save
        end
        
        it "references the program" do
          expect(bike_not_asgnd.program).to eq program
#          expect(bike_not_asgnd.application).to eq program
        end

        it "is not available" do
          expect(bike_not_asgnd).to_not be_available
        end

        it "is not departed" do
          expect(bike_not_asgnd).to_not be_departed
        end
      end # describe "is assigned to a program"
    end
  end #   context "without an assignment"

  context "the bike number is changed" do
    subject(:bike){FactoryGirl.create(:bike)}
    let(:new_number){FactoryGirl.generate(:bike_number)}

    before :each do
      bike.number = new_number
    end
    
    it "is allowed" do
      expect(bike).to be_valid
    end
  end # context "the bike number is changed"


  context "with an assignment" do
    let(:assignment){FactoryGirl.create(:assignment)}
    subject(:bike){assignment.bike}


    it "is not available" do
      expect(bike).to_not be_available
    end

    it "references the assignment" do
      expect(bike.assignment).to eq assignment
    end

    describe "being assigned" do
      let(:program){FactoryGirl.create(:program)}
      let(:new_assignment){Assignment.build(:bike => bike, :program => program)}

      before :each do
        new_assignment.save
        bike.reload
      end
      
      it "is not valid" do
        expect(new_assignment).to_not be_valid
      end

      it "does not change the bike assignment" do
        expect(bike.assignment).to_not eq new_assignment
        expect(bike.assignment).to eq assignment
      end
    end

    context "which is canceled" do

      before :each do
        bike.assignment.destroy
        bike.reload
      end

      it "is be available" do
        expect(bike).to be_available
      end

      it "has no assignment" do
        expect(bike.assignment).to be_nil
      end

      # it "has a record of the canceled assignment"
      
    end # context "which is canceled" do
    
    context "in the shop" do    
      it "can be destroyed" do
        expect {bike.destroy.to change(Bike, :count).by(-1)}
      end
    end # context "in the shop" do
  end # context "with an assignment"

  context "which is departed" do
    let(:assignment){FactoryGirl.create(:assignment)}
    subject(:bike){assignment.bike}
    let(:departure){Departure.build(:bike => bike, :value => 0)}

    before :each do
      departure.save
      bike.reload
    end

    it "is departed" do
      expect(bike).to be_departed
    end

    it "has a departure" do
      expect(bike.departure).to_not be_nil
    end

    it "does not have a program" do
      expect(bike.program).to be_nil
    end

    describe "destroying assignment" do

      before :each do
        bike.assignment.destroy
        bike.reload
      end
      
      it "is returns the bike to the sop" do
        expect(bike).to_not be_departed
      end

    end

  end

end


