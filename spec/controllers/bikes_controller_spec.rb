require 'spec_helper'

include Devise::TestHelpers

describe BikesController do
  let(:sig){"ABC"}
  let(:user){FactoryGirl.create(:user)}
  
  describe "GET index" do
    context "as a guest user" do
      
      # Trick Devise into expecting
      # no user to be signed-in
      #
      # See
      # http://kconrails.com/2010/10/16/testing-visitors-in-devise-with-rspec/
      before :each do
        sign_out :user
      end
      
      it "should be successful" do
        get :index
        expect(response).to be_success
      end
    end # context "as a guest user"
  end # describe "GET index"

  describe "GET new" do
    context "when signed-in" do
      before :each do
        sign_in user        
      end
    
      it "is successful" do
        get :new
        expect(response).to be_success
        response.should be_success
      end
      
      it "exposes a new bike" do
        expect(controller.bike).to_not be_nil
        expect(controller.bike).to_not be_persisted
      end
    end # context "when signed-in"

    context "while not signed in" do
      before :each do
        sign_out :user
      end

      it "should not be successful" do
        get("new")
        response.should_not be_success
      end
    end # context "while not signed in"
  end

  describe "GET 'edit' a bike" do
    let(:bike){FactoryGirl.create(:bike)}
    
    context "when signed in" do
      before(:each) do
        sign_in user
        get :edit, :id => bike
      end
      
      it "should expose the correct bike" do
        expect(Bike.find(bike)).to_not be_nil
        expect(controller.bike).to_not be_nil
        expect(controller.bike.id).to eq(bike.id)
      end
    end # context "when signed in"
  end

  describe "Put update" do
    let(:bike){FactoryGirl.create(:bike)}
    
    context "when signed in" do

      before :each do
        sign_in user
      end

      context "without a signatory" do
        before(:each) do
        put :update, :id => bike, :sig => nil
        end
        
        it "gives errors" do
          expect(controller.flash[:error]).to_not be_nil
        end
      end
      
      context "with valid parameters" do
        
        before(:each) do
          put :update, :id => bike, :sig => sig
        end
        
        it "should redirect to the bike" do
        expect(controller.bike_form.bike.id).to eq(bike.id)
          expect(response).to redirect_to(bike)
        end
      end
      
      context "with invalid paramaters" do
        before :each do
          put :update, :id => bike, :bike_form=> {:number => 'BAD'}, :sig => sig
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
              put :update, :id=>bike_with_model, :bike_form=> params, :sig => sig
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
              put :update, :id=>bike, :bike_form=> params, :sig => sig
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
              put :update, :id=>bike, :bike_form=> params, :sig => sig
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
              put :update, :id=>bike, :bike_form=> params, :sig => sig
              bike.reload
            end
            
            it "assigns the brand to the model" do
              expect(bike.model.brand).to eq brand            
            end
            
            it "associates the a new model with the given name with the bike" do
              expect(bike.model.name).to eq(new_model_name)
            end
            
          end # context "when brand_id and model_name are given"
        
        end # context "when a model is pre-assigned"
        
        context "when a model is not pre-assigned"
        
      end # describe "editing model and brand"
      
    end # context "when signed in"
    
  end # "Put update"  
  
  describe "POST create" do
    context "when signed in" do
      before :each do
        sign_in user
      end
      context "without a signatory" do
        let(:params){{:number => FactoryGirl.generate(:bike_number), :color => "ffffff"}}
        
        before :each do
          post :create, :bike_form => params, 
          :commit => I18n.translate('commit_btn.new'), :sig => nil
          @bike = Bike.where{number == my{params[:number]}}.first 
        end
      
        it "does not create the bike" do
        expect(@bike).to be_nil
        end
      end
      
      context "with valid parameters" do    
        let(:params){{:number => FactoryGirl.generate(:bike_number), :color => "ffffff"}}
        
        before :each do
          post :create, :bike_form => params, 
          :commit => I18n.translate('commit_btn.new'), :sig => sig

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
          post :create, :bike_form => params, 
          :commit => I18n.translate('commit_btn.new'), :sig => sig
        end
        
        it "renders the new bike page" do
          expect(response).to render_template(:new)
        end

        it "does not creates a bike" do
          expect(Bike.where{number == my{params[:number]}}.first).to be_nil
        end
      end # context "with invalid parameters"
    end # context "when signed in"
  end # POST

  describe "GET 'show'" do
    context "when signed in" do
      before :each do
        sign_in user
      end
      
      context "bike without a hook when one is available" do
      let(:hook){FactoryGirl.create(:hook)}
        let(:bike){FactoryGirl.create(:bike)}
        before(:each) do
          hook
          get :show, :id => bike
        end
        
        it "show the bike page with success" do
          expect(response).to be_success
        end
        
        it "exposes the correct bike" do
          expect(controller.bike).to_not be_nil
          expect(controller.bike.id).to eq(bike.id)
        end
      end
    end # context "when signed in"
  end

  describe "DELETE 'destroy'" do

    context "when signed in" do
      before :each do
        sign_in user
      end
      
      context "A bike without a project" do
        subject(:bike){FactoryGirl.create(:bike)}
        before(:each) do
          delete :destroy, :id => bike
        end
        
        it "should redirect" do
          expect(response).to redirect_to(root_path)
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
          expect(response).to redirect_to(root_path)
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
          expect(response).to redirect_to(root_path)
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
          expect(response).to redirect_to(root_path)
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
      end # context "a departed bike with a destination"

    end # context "when signed in" do
  end # describe "DELETE 'destroy'"

  describe "GET 'qr'" do
    context "when signed in" do
      before :each do
        sign_in user
      end
      
      let(:bike){FactoryGirl.create(:bike)}
      before(:each) do
        get :qr, :id => bike
      end
      
      it "renders the qr with success" do
        expect(response).to be_success
      end
    end # context "when signed in"
  end # describe "GET 'qr'"

end
