require 'spec_helper'

describe BikeForm do
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

  describe "A form for an existing bike,and params" do

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

