require 'spec_helper'

describe BikesController do
  describe "GET new" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should expose a new bike" do
      expect(controller.bike).to_not be_nil
      expect(controller.bike).to_not be_persisted
    end

  end

  describe "GET index" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "Get edit a bike" do
    before(:each) do
      @bike  = FactoryGirl.create(:bike)
      get :edit, :id => @bike
    end
    it "should expose the correct bike" do
      expect(controller.bike).to_not be_nil
      expect(controller.bike.id).to eq(@bike.id)
    end

  end

  describe "Put update a bike" do
    before(:each) do
      @bike  = FactoryGirl.create(:bike)
    end
    
    describe "with valid parameters" do
      it "should redirect to the bike" do
        put :update, :id => @bike
        expect(response).to redirect_to(@bike)
      end
    end

    describe "with invalid paramaters" do
      it "should render edit" do
        put :update, :id => @bike, :bike_form=> {:number => 'BAD'}
        expect(response).to_not redirect_to(@bike)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "GET new while not signed in" do
    it "should be successful" do
      get("new")
      response.should be_success
    end
  end

  describe "Show bike" do
    before(:each) do
      @bike  = FactoryGirl.create(:bike)
      get :show, :id => @bike
    end
    
    it "should show bike page with success" do
      expect(response).to be_success
    end

    it "should expose the correct bike" do
      expect(controller.bike).to_not be_nil
      expect(controller.bike.id).to eq(@bike.id)
    end
    
  end

  describe "A bike reserving a hook" do

    it "should reserve the requested aviailable hook" do 
        
      hook = FactoryGirl.create(:hook)
      bike = FactoryGirl.create(:bike)
      #bike.should be_shop
      bike.hook.should be_nil

      put :reserve_hook, {:id => bike, :hook_id => hook.id}
      flash[:success].should == "Hook #{hook.number} reserved successfully"
      flash[:error].should_not == "Could not reserve the hook."

      bike.reload
      bike.hook.should_not be_nil
      bike.hook.should == hook

    end

    it "Should not have a bike after vacating" do
      hook = FactoryGirl.create(:hook)
      bike = FactoryGirl.create(:bike)
      bike.should be_shop
      bike.hook.should be_nil
      put :reserve_hook, {:id => bike, :hook_id => hook.id}
      bike.reload
      bike.hook.should_not be_nil

      put :vacate_hook, {:id => bike}
      bike.reload
      bike.hook.should be_nil
    end
    
  end


  describe "DELETE" do
    before(:each) do
      @proj = FactoryGirl.create(:youth_project)
      @p_id = @proj.id
      @pdet_id = @proj.detail.id
      @bike = @proj.bike
      @b_id = @bike.id
      @bike.destroy
      @bike.reload
    end
    
    it "should be successful"

    describe "A bike without a project" do
      before(:each) do
        @bike = FactoryGirl.create(:bike)
      end
      it "should be succssful"
    end

    describe "A bike without a project" do
      before(:each) do
      @bike = FactoryGirl.create(:bike)
      end
      it "should be succssful"
    end
  end

  describe "DEPART" do

    describe "that is not in the shop" do
      it "should redirect to SHOW bike"
      it "should FLASH message that bike has already departed"
    end

    describe "A bike without a project" do
      before(:each) do
        @bike = FactoryGirl.create(:bike)
      end

      it "should render depart page"
    end

    describe "with a done project" do
      before(:each) do
        @proj = FactoryGirl.create(:done_youth_project)
        @bike = @proj.bike
      end
      
      it "should redirect to to FINISH project"
    end

    describe "with an incomplete project" do
      before(:each) do
        @proj = FactoryGirl.create(:youth_project)
        @bike = @proj.bike
      end

      it "should render depart page"
      
    end
    
  end # describe "DEPART"

end
