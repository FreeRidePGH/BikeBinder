require 'spec_helper'

describe BikeModel do
  subject(:model){FactoryGirl.create(:bike_model)}
  it "is valid" do
    expect(model).to be_valid
  end

  context "with a numerical seat-tube height measurement" do
    subject(:bike){Bike.new(:seat_tube_height => 55)}
    before :each do
      bike.valid?
    end
    it "does not have seat tube height errors" do
      expect(bike.errors[:seat_tube_height]).to be_empty
    end
  end # context "with a numerical seat-tube height measurement"


  context "with a numerical seat-tube height measurement" do
    subject(:bike){Bike.new(:top_tube_length => 50)}
    before :each do
      bike.valid?
    end
    it "does not have top tube length errors" do
      expect(bike.errors[:top_tube_length]).to be_empty
    end
  end # context "with a numerical top-tube length measurement"


  context "with a new brand" do
    subject(:model_with_brand){FactoryGirl.create(:bike_model_with_brand)}
    it "is valid" do
      expect(model_with_brand).to be_valid
    end
    
    it "has a brand" do
      expect(model_with_brand.brand).to_not be_nil
   end

    it "has a valid brand" do
      expect(model_with_brand.brand).to be_valid
    end
  end # context "with a new brand"

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

end
