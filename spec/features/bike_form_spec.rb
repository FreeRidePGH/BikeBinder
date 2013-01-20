require 'spec_helper'

describe "The bike form", :type => :feature do
  before(:each) do
    @brand = FactoryGirl.create(:bike_brand)
    @model = FactoryGirl.create(:bike_model)
    @bike  = FactoryGirl.create(:bike)
    @new_model = FactoryGirl.create(:bike_model)
  end

  context "for a new bike" do
    it "has required inputs" do
      visit new_bike_path
      expect(page).to have_content "Color"
      expect(page).to have_content "Number"
    end
  end

  describe "brand and model use case" do

    # Different use cases for editing the brand and model
    # 
    # * User finds the model they want
    # * User finds the brand they want, but creates the model
    # * User creates a brand and model
    # * User knows model but not the brand
    #  * There is a model that already exists for this case
    #  * There is no existing model for this case
    # * User knows the brand but not the model
    #  * The brand already exists
    #  * The brand does not exist
    
    describe "creating the brand and model" do
      context "while editing an existing bike" do
        before :each do
          visit edit_bike_path(@bike)
          @new_model_name = 'test_model_123'
          @new_brand_name = 'test_brand_123'
        end

        it "should create and assign the model with correct model name and brand name" do
          page.choose('bike_form_brand_action_create')
          fill_in 'Brand', :with => @new_brand_name
          fill_in 'Model', :with => @new_model_name
          click_button I18n.translate('commit_btn')[:edit]
          @bike.reload
          expect(@bike.model.name).to eq(@new_model_name)
          expect(page).to have_content @new_brand_name
          expect(page).to have_content @new_model_name
        end

      end # context "for editing an existing bike" do
      
      context "for creating a new bike" do
      end # context "for creating a new bike" do

    end #  describe "editing the brand and model" do

  end #   describe "bike brand and model use case"

end # describe "The bike form", :type => :feature do
