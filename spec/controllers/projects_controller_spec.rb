require 'spec_helper'

describe ProjectsController do

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

end
