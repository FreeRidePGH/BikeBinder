require 'spec_helper'

describe BikeModel do
  subject(:model){FactoryGirl.create(:bike_model)}
  it "is valid" do
    expect(model).to be_valid
  end

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
  end
end
