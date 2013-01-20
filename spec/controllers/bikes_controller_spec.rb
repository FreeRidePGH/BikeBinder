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
      expect(Bike.find(@bike)).to_not be_nil
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
        expect(controller.bike_form.bike.id).to eq(@bike.id)
        expect(controller.bike_form.bike_model_id).to eq(@bike.bike_model_id.to_s)
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
    
    describe "editing model and brand" do
      describe "on a bike that already has a model assigned" do
        before(:each) do
          @brand = FactoryGirl.create(:bike_brand)
          @model = FactoryGirl.create(:bike_model)
          @bike  = FactoryGirl.create(:bike)
          @new_model = FactoryGirl.create(:bike_model)
        end

        it "should not be changed if the same model_id is given" do
          params = {:bike_model_id => @bike.model.id}
          id0 = @bike.model.id
          put :update, :id=>@bike, :bike_form=> params
          expect(@bike.model.id).to eq(id0)
        end

        it "should change model when a model_id as given" do
          params = {:bike_model_id => @new_model.id}
          id0 = @bike.model.id
          put :update, :id=>@bike, :bike_form=> params
          @bike.reload

          #expect(response).to be_success
          expect(controller.bike_form.bike_model_id.to_s).to eq(@new_model.id.to_s)
          expect(@bike.model.id).to eq(@new_model.id)
          expect(@bike.model.id).to_not eq(id0)
        end

        it "should change a model when new brand and model name are given" do
          params = {
            :bike_model_name => @bike.model.name+' edit',
            :bike_brand_name => @bike.model.brand.name+' edit',
            :bike_brand_id => '',
            :bike_model_id => '',
            :brand_action => 'create'
          } 
          put :update, :id=>@bike, :bike_form=> params
          # expect(response).to be_success
          @bike.reload
          # puts request.params
          expect(controller.bike.id).to eq(@bike.id)
          expect(controller.bike_form.bike_model_id).to_not eq(@model.id)
          expect(controller.bike_form.bike_model_id).to be_nil
          expect(controller.bike_form.bike_brand_id).to be_nil
          expect(controller.bike_form.bike_brand_name).to eq(params[:bike_brand_name])
          
          expect(@bike.bike_model_id).to_not eq(@model.id)
          expect(@bike.model.name).to eq(params[:bike_model_name])
        end

        it "should change a model when brand_id and model name are given" do
          brand = FactoryGirl.create(:bike_brand)
          params = {
            :bike_model_name => 'model',
            :bike_brand_id => brand.id
          }
          put :update, :id=>@bike, :bike_form=> params
          @bike.reload
          expect(@bike.model.brand.id).to eq(params[:bike_brand_id])
          expect(@bike.model.name).to eq(params[:bike_model_name])
        end
      end

      describe "on a bike without a model assigned" do
        
        
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

    it "should reserve the requested aviailable hook"
    if false # not implemented
        
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

    it "Should not have a bike after vacating"
    if false # not implemented
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
