require 'rails_helper'

describe PagesController do
  let(:user){FactoryGirl.create(:volunteer_user)}

  describe "GET 'index'" do
    before :each do
      # sign_out :user
      sign_in user
    end

    it "should be successful" do
      get :index
      expect(response).to be_success
    end

  end # desctibe "GET 'index'"

  describe "GET 'show' 'incoming_bike_instructions'" do
    before :each do
      # sign_out :user
      sign_in user
    end

    it "should be successful" do
      get 'show', :id=>"incoming_bike_instructions"
      expect(response).to be_success
    end
  end # desctibe "GET 'show'"

  describe "GET 'show' 'frame_measurements.svg'" do
    before :each do
      # sign_out :user
      sign_in user
    end

    it "should be successful for html" do
      get 'show', :id=>"frame_measurements"
      expect(response).to be_success
    end

    it "should be successful for svg" do
      get 'show', :id=>"frame_measurements.svg"
      expect(response).to be_success
    end
  end # desctibe "GET 'show'"

end # describe SearchesController
