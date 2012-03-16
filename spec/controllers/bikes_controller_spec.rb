require 'spec_helper'

describe BikesController do

  describe "GET new" do
    it "should be successful" do
      get :new
      response.should be_success
    end
  end

  describe "GET index" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "Enter new bike"

  describe "Get new while not signed in" do
    it "should be successful" do
      get("new")
      response.should be_success
    end
  end

end
