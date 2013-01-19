require 'spec_helper'

describe "The bike form", :type => :feature do
  before(:each) do
    @brand = FactoryGirl.create(:bike_brand)
    @model = FactoryGirl.create(:bike_model)
    @bike  = FactoryGirl.create(:bike)
    @new_model = FactoryGirl.create(:bike_model)
  end

  it "can add a new bike" do
    visit new_bike_path
    expect(page).to have_content "Color"
    expect(page).to have_content "Number"
  end


end
