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

  describe "Get bike" do
    
    it "should show bike page with success" do
      @bike  = FactoryGirl.create(:bike)
      get :show, :id => @bike
      response.should be_success      
    end
    
  end

  describe "A bike reserving a hook" do

    it "should reserve the requested aviailable hook" do 
        
      @hook = FactoryGirl.create(:hook)
      @bike = FactoryGirl.create(:bike)

      @bike.should be_shop
      @bike.hook.should be_nil
        
      put :reserve_hook, {:id => @bike, :hook_id => @hook.id}

      flash[:success].should == "Hook #{@hook.number} reserved successfully"
      flash[:error].should_not == "Could not reserve the hook."

      @bike.hook.should_not be_nil
      @bike.hook.should == @hook

      response.should be_success
        
      end
    
  end
  

end
