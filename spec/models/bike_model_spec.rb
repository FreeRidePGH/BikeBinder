require 'rails_helper'

RSpec.describe BikeModel, :type=>:model do
  subject(:model){FactoryGirl.create(:bike_model)}
  it "is valid" do
    expect(model).to be_valid
  end

  context "with a numerical seat-tube height measurement" do
    let(:params){ActionController::Parameters.new(:seat_tube_height => 55).permit(:seat_tube_height)}
    subject(:bike){Bike.new(params)}
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

  context "associated in factory" do
    subject(:bike){FactoryGirl.create(:associated_bike)}

    it "is valid" do
      expect(bike).to be_valid
    end
  end
end
