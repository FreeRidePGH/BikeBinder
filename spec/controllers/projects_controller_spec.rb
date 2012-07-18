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
      get :show, {:id => @proj.bike.label}
      response.should be_success
    end

    it "should be successful" do
      get :show, {:id => @proj.label}
      response.should be_success
    end
  end

  describe "GET 'finish'" do
    it "should be successful"
  end


  describe "PUT close" do
    
    describe "with a done projecet" do
      it "should be successful"
      it "should redirect to SHOW bike"
    end

    describe "with an incomplete project" do
      describe "when the option to override is specified" do
        it "should be successful"
        it "should redirect to SHOW bike"
      end
      
      describe "when no option to overrirde is given" do
        it "should FLASH an error"
        it "should redirect to SHOW project"
      end
    end

    describe "and is successful" do
      it "should FLASH success"
    end

    describe "and fails" do
      it "should FLASH the error"
    end

  end

end
