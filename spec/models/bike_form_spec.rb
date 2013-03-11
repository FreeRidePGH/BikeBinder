require 'spec_helper'

describe BikeForm do
  
  it "has a params list with correct items" do
    expect(BikeForm.form_params_list).to include(:bike_brand_name)
  end

  before :each do
    @brand = FactoryGirl.create(:bike_brand)
    @model = FactoryGirl.create(:bike_model)
    @bike = FactoryGirl.create(:bike)
  end
  
  context "existing bike, blank params" do
    let(:bike){FactoryGirl.create(:bike)}
    subject(:form){BikeForm.new(bike)}

    it "has the correct bike assigned" do
      expect(form.bike).to eq bike
    end
  end

  context "for creating a model and brand" do
    let(:bike){FactoryGirl.create(:bike_with_model)}
    let(:new_model_name){FactoryGirl.generate(:bike_model_name)}
    let(:new_brand_name){FactoryGirl.generate(:bike_brand_name)}
    let(:params) do
      {
        :bike_model_name => new_model_name,
        :bike_model_id => '',
        :bike_brand_id => '',
        :bike_brand_name => new_brand_name
        }
    end
    subject(:form){BikeForm.new(bike, params)}

    before :each do
      @model0 = bike.model
      @brand0 = bike.model.brand
      @saved = form.save
    end

    it "saved successfully" do
      expect(@saved).to be_true
    end

    it "is valid" do
      expect(form).to be_valid
    end

    it "overrides the model name" do
      expect(form.bike_model_name).to eq new_model_name
    end

    it "overrides the brand name" do
      expect(form.bike_brand_name).to eq new_brand_name
    end

    it "assigns the model name" do
      expect(form.bike.model.name).to eq(new_model_name)
    end

    it "assigns the brand name" do
        expect(bike.model.brand.name).to eq(new_brand_name)
    end
        
    it "creates a new model" do
      expect(bike.model).to_not be_nil
      expect(bike.model).to_not eq @model0
    end

    it "creates a new brand" do
      expect(bike.model.brand).to_not be_nil
      expect(bike.model.brand).to_not eq @brand0
    end

  end # context "for creating a new model and new brand" do

  context "for creating a new model with an existing brand" do
    let(:bike){FactoryGirl.create(:bike_with_model)}    
    let(:brand){bike.model.brand}    
    let(:new_model_name){FactoryGirl.generate(:bike_model_name)}    
    let(:params) do
      {
          :bike_model_name => new_model_name,
          :bike_model_id => '',
          :bike_brand_id => '',
          :bike_brand_name => brand.name
        }
    end
    subject(:form){BikeForm.new(bike, params)}    
    before :each do
      form.save
    end

    it "is valid" do
      expect(form).to be_valid
    end

    it "keeps the same brand name" do
      expect(form.bike_brand_name).to eq brand.name
    end

    it "overrides the model name in the form" do
      expect(form.bike_model_name).to eq new_model_name
    end

    it "associates the new model with the bike" do
        expect(bike.model.name).to eq(new_model_name)
    end    
    
  end # context "for creating a new model with an existing brand"

end # describe BikeForm do

