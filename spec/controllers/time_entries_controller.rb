require 'spec_helper'

describe TimeEntriesController do

  before(:each) do
    @proj||=Project.all.first
    unless @proj
      d = FactoryGirl.build(:youth_detail)
      @proj = d.proj
      @proj.detail = d
    end
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get :show, {:bike_id => @proj.bike.number}
      response.should be_success
    end
  end

  describe "GET 'enter'" do
    it "should be successful" do
      get :enter
      response.should be_success
    end
  end

  describe "POST 'hours/enter'" do
    it "should add a new entry" do
      # Testing nested resources
      # http://stackoverflow.com/questions/8047052/testing-nested-controller-action-with-rspec

      post :create, :project_id => @proj
      response.should redirect_to(project_path(@proj))
    end
  end

end
