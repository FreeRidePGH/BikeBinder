require 'spec_helper'

describe BikesController do
  describe "GET new" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "exposes a new bike" do
      expect(controller.bike).to_not be_nil
      expect(controller.bike).to_not be_persisted
    end

  end

  describe "GET index" do
    it "should be successful" do
      get :index
      expect(response).to be_success
    end
  end

  describe "Get edit a bike" do
    let(:bike){FactoryGirl.create(:bike)}
    before(:each) do
      get :edit, :id => bike
    end

    it "should expose the correct bike" do
      expect(Bike.find(bike)).to_not be_nil
      expect(controller.bike).to_not be_nil
      expect(controller.bike.id).to eq(bike.id)
    end
  end

  describe "Put update" do
    let(:bike){FactoryGirl.create(:bike)}
    context "with valid parameters" do
      
      before(:each) do
        put :update, :id => bike
      end
      
      it "should redirect to the bike" do
        expect(controller.bike_form.bike.id).to eq(bike.id)
        expect(response).to redirect_to(bike)
      end
    end
    
    context "with invalid paramaters" do
      before :each do
        put :update, :id => bike, :bike_form=> {:number => 'BAD'}
      end
      it "should render edit" do
        expect(response).to_not redirect_to(@bike)
        expect(response).to render_template(:edit)
      end
    end

    describe "model and brand" do

      let(:brand){FactoryGirl.create(:bike_brand)}
      let(:model0){FactoryGirl.create(:bike_model)}
      let(:bike){FactoryGirl.create(:bike)}
      let(:model1){FactoryGirl.create(:bike_model)}

      context "when a model is already assigned" do

        let(:bike_with_model){FactoryGirl.create(:bike_with_model)}

        context "the same model_id is given" do
          let(:model_id){bike_with_model.model.id}
          let(:params) do 
            {
              :number => bike_with_model.number,
              :color => bike_with_model.color,
              :bike_model_id => model_id,
              :bike_brand_id => nil,
              :bike_model_name => '',
              :bike_brand_name => ''
            }
          end
          before :each do
            put :update, :id=>bike_with_model, :bike_form=> params            
            bike.reload
          end

          it "does not change the model" do
            expect(bike_with_model.model.id).to eq(model_id)
          end
        end

        context "a different model_id is given" do
          let(:initial_model){model0}
          let(:given_model){model1}
          let(:params) do
            {
              :number => bike.number,
              :color => bike.color,
              :bike_model_id => given_model.id
            }
          end
          before :each do
            bike.model = initial_model
            put :update, :id=>bike, :bike_form=> params
            bike.reload
          end

          it "changes the model" do
            expect(bike.model.id).to_not eq(initial_model.id)            
          end

          it "updates the model to the given model" do
            expect(controller.bike_form.bike_model_id.to_s).to eq(given_model.id.to_s)
            expect(bike.model.id).to eq(given_model.id)
          end
        end # context "new model_id is given"

        context "new brand and model names are given" do
          let(:brand_name){FactoryGirl.generate(:bike_brand_name)}
          let(:model_name){FactoryGirl.generate(:bike_model_name)}
          let(:params) do
            {
              :number => bike.number,
              :color => bike.color,
              :bike_model_name => model_name,
              :bike_brand_name => brand_name,
              :bike_brand_id => '',
              :bike_model_id => '',
              :brand_action => 'create'
            } 
          end
          subject(:bike){FactoryGirl.create(:bike_with_model)}
          let(:initial_model){bike.model}
          let(:initial_brand){initial_model.brand}
          
          before :each do
            initial_brand
            put :update, :id=>bike, :bike_form=> params
            bike.reload
          end

          it "updates the bike" do
            expect(controller.bike.id).to eq(bike.id)
          end

          it "updates the model" do
            expect(controller.bike_form.bike_model_id).to_not eq(initial_model.id)
          end

          it "does not assigne ids to the form" do
            expect(controller.bike_form.bike_model_id).to be_nil
            expect(controller.bike_form.bike_brand_id).to be_nil
          end

          it "assigns the name to the form" do
            expect(controller.bike_form.bike_brand_name).to eq(params[:bike_brand_name])
          end

          it "creates the brand" do
            expect(bike.model.brand).to_not eq(initial_brand)
          end

          it "creates the model" do
            expect(bike.bike_model_id).to_not eq(initial_model.id)
          end

          it "assigns the correct name to the created model" do
            expect(bike.model.name).to eq(params[:bike_model_name])
          end
        end # context "new brand and model names are given" 

        context "when brand_id and model_name are given" do
          let(:brand){FactoryGirl.create(:bike_brand)}
          let(:new_model_name){FactoryGirl.generate(:bike_model_name)}
          let(:params) do
            {
              :number => bike.number,
              :color => bike.color,
              :bike_model_name => new_model_name,
              :bike_brand_id => brand.id
            }
          end
          
          before :each do
            put :update, :id=>bike, :bike_form=> params
            bike.reload
          end

          it "assigns the brand to the model" do
            expect(bike.model.brand).to eq brand            
          end

          it "associates the a new model with the given name with the bike" do
            expect(bike.model.name).to eq(new_model_name)
          end

        end
        
      end # context "when a model is pre-assigned"

     context "when a model is not pre-assigned"

    end # describe "editing model and brand"

  end # "Put update"  

  describe "POST create" do
    context "with valid parameters" do    
      let(:params){{:number => FactoryGirl.generate(:bike_number), :color => "ffffff"}}

      before :each do
        post :create, :bike_form => params, :commit => I18n.translate('commit_btn.new')
        @bike = Bike.where{number == my{params[:number]}}.first 
      end

      it "redirects to bike" do
        expect(response).to redirect_to(@bike)
      end
      
      it "creates a bike" do
        expect(@bike).to_not be_nil
      end
    end # context "with valid parameters"

    context "with invalid parameters" do
      let(:params){{:number => FactoryGirl.generate(:bike_number)}}

      before :each do
        post :create, :bike_form => params, :commit => I18n.translate('commit_btn.new')
      end
      
      it "renders the new bike page" do
        expect(response).to render_template(:new)        
      end

      it "does not creates a bike" do
        expect(Bike.where{number == my{params[:number]}}.first).to be_nil
      end
    end # context "with invalid parameters"
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

  describe "DELETE 'destroy'" do
    context "A bike without a project" do
      subject(:bike){FactoryGirl.create(:bike)}
      before(:each) do
        delete :destroy, :id => bike
      end

      it "should redirect" do
        expect(response).to redirect_to(bikes_path)
      end

      it "should delete the bike" do
        expect(Bike.where{id=my{bike.id.to_i}}.first).to be_nil
      end

    end

    context "A bike with a project" do
      let(:assignment){FactoryGirl.create(:assignment)}
      subject(:bike){assignment.bike}

      before(:each) do
        delete :destroy, :id => bike
      end

      it "should redirect" do
        expect(response).to redirect_to(bikes_path)
      end

      it "should delete the bike" do
        expect(Bike.where{id=my{bike.id.to_i}}.first).to be_nil
      end

      it "should delete the assignment" do
        expect(Assignment.where{id=my{assignment.id.to_i}}.first).to be_nil
      end
    end

    context "a departed bike with a project" do
      let(:assignment){FactoryGirl.create(:assignment_departed_prog)}
      subject(:bike){assignment.bike}
      before(:each) do
        delete :destroy, :id => bike
      end

      it "should redirect" do
        expect(response).to redirect_to(bikes_path)
      end

      it "should delete the bike" do
        expect(Bike.where{id=my{bike.id.to_i}}.first).to be_nil
      end

      it "should delete the assignment" do
        expect(Assignment.where{id=my{assignment.id.to_i}}.first).to be_nil
      end

      it "should delete the departure" do
        expect(Departure.where{bike_id=my{bike.id.to_i}}.first).to be_nil        
      end

    end

    context "a departed bike with a destination" do
      let(:assignment){FactoryGirl.create(:assignment_departed_dest)}
      subject(:bike){assignment.bike}
      before(:each) do
        delete :destroy, :id => bike
      end

      it "should redirect" do
        expect(response).to redirect_to(bikes_path)
      end

      it "should delete the bike" do
        expect(Bike.where{id=my{bike.id.to_i}}.first).to be_nil
      end

      it "should delete the assignment" do
        expect(Assignment.where{id=my{assignment.id.to_i}}.first).to be_nil        
      end

      it "should delete the departure" do
        expect(Departure.where{bike_id=my{bike.id.to_i}}.first).to be_nil        
      end

    end
    
  end # describe "DELETE 'destroy'"
  
end
