require 'spec_helper'

describe BikeForm do

  it "should have a params list with correct items" do
    expect(BikeForm.form_params_list).to include(:bike_brand_name)
  end

  before :each do
    @brand = FactoryGirl.create(:bike_brand)
    @model = FactoryGirl.create(:bike_model)
    @bike = FactoryGirl.create(:bike)
  end

  describe "A form for an existing bike, blank params" do
    before :each do
      @form = BikeForm.new(@bike)
    end
    
    it "should have the correct bike assigned" do
      expect(@form.bike).to eq(@bike)
    end
  end

  describe "For editing a bike" do

    describe "creating a model and brand" do
      it "should create and assign the new model with brand info" do
        @params = {
          :bike_model_name => @bike.model.name+'edit',
          :bike_model_id => '',
          :bike_brand_id => '',
          :bike_brand_name => @bike.model.brand.name+"edit"
        }
        @form = BikeForm.new(@bike, @params)
        saved = @form.save
        expect(saved).to be_true
        expect(@bike.model.name).to eq(@params[:bike_model_name])
        expect(@bike.model.brand.name).to eq(@params[:bike_brand_name])
        
        expect(@bike.model.id).to_not  eq(@model.id)
        expect(@bike.model.brand.id).to_not eq(@brand.id)
      end
    end

    describe "for a new model for an existing brand" do
      before :each do
        @params = {
          :bike_model_name => 'model',
          :bike_brand_id => @brand.id,
          :bike_model_id => ''
        }
        @form = BikeForm.new(@bike, @params)
      end
        
      it "should have model name overriding model from the bike" do
        expect(@form.bike_model_name).to eq(@params[:bike_model_name])
      end

      it "should not have a model_id assigned" do
        expect(@form.bike_model_id).to be_nil
      end

      it "should save the new model name to the bike" do
        saved = @form.save
        expect(saved).to be_true
        expect(@bike.model.name).to eq(@params[:bike_model_name])
      end
    end
  end

  
  

end

