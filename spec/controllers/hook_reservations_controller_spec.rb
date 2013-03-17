require 'spec_helper'

describe HookReservationsController do
  
  # POST is the RESERVE action
  describe "POST 'create'" do
    context "with valid bike and hook" do
      let(:bike){FactoryGirl.create(:bike)}
      let(:hook){FactoryGirl.create(:hook)}
      
      before :each do
        post :create, :bike_id => bike, :hook_id => hook
      end
      
      it "specifies the hook in the request params" do
        expect(request.params[:hook_id]).to_not be_nil
        expect(request.params[:hook_id]).to eq hook.slug
      end
      
      it "specifies the bike int the request params" do
        expect(request.params[:bike_id]).to_not be_nil
        expect(request.params[:bike_id]).to eq bike.slug
      end
    
      it "reserves the hook" do
        expect(hook.reservation).to_not be_nil
      end
      
      it "assigns the hook to the bike" do
        expect(bike.hook).to eq hook
      end
      
      it "assigns the bike to the hook" do
        expect(hook.bike).to eq bike
      end
    end # context "with valid bike and hook"

    context "with already reserved bike and valid hook" do
      let(:pre_reservation){FactoryGirl.create(:hook_reservation)}
      let(:parked_bike){pre_reservation.bike}
      let(:parking_hook){pre_reservation.hook}
      let(:hook){FactoryGirl.create(:hook)}

      before :each do
        post :create, :bike_id => parked_bike, :hook_id => hook
      end

      it "does not reserve the hook" do
        expect(hook.bike).to be_nil
      end

      it "keeps the bike parked on original hook" do
        expect(parked_bike.hook).to_not be_nil
        expect(parked_bike.hook).to eq parking_hook
      end
    end

    context "with valid bike and already reserved hook" do 
      let(:pre_reservation){FactoryGirl.create(:hook_reservation)}
      let(:bike){FactoryGirl.create(:bike)}
      let(:hook){pre_reservation.hook}

      before :each do
        post :create, :bike_id => bike, :hook_id => hook
      end

      it "does not assign a hook to the bike" do
        expect(bike.hook).to be_nil
      end

      it "keeps the original assignment for the hook" do
        expect(hook.bike).to_not be_nil
        expect(hook.bike).to_not eq bike
      end
    end

    context "with bike reserving different hook and hook reserving different bike" do
      let(:pre_reservationA){FactoryGirl.create(:hook_reservation)}
      let(:pre_reservationB){FactoryGirl.create(:hook_reservation)}
      let(:bike){pre_reservationA.bike}
      let(:hook){pre_reservationB.hook}

      before :each do
        post :create, :bike_id => bike, :hook_id => hook
      end
      
      it "does not assign the hook to the bike" do
        expect(bike.hook).to_not eq hook
      end

      it "does not assign the bike to the hook" do
        expect(hook.bike).to_not eq bike
      end

      it "keeps the bike's hook" do
        expect(bike.hook).to_not be_nil
      end

      it "keeps the hook's bike" do
        expect(hook.bike).to_not be_nil
      end
    end

    context "with bike that is already reserving given hook" do
      let(:pre_reservation){FactoryGirl.create(:hook_reservation)}
      let(:bike){pre_reservation.bike}
      let(:hook){pre_reservation.hook}

      before :each do
        post :create, :bike_id => bike, :hook_id => hook
      end

      it "keeps the bike assigned to the hook" do
        expect(bike.hook).to eq hook
      end

      it "keeps the hook assigned to the bike" do
        expect(hook.bike).to eq bike
      end

      it "does not create a new reservation" do
        expect(bike.hook_reservation).to eq pre_reservation
      end
    end

  end # describe "POST 'create'"


  # DELETE is the VACATE action
  describe "DELETE destroy" do

    context "when a given reservation is found" do
      subject(:reservation){FactoryGirl.create(:hook_reservation)}
      let(:bike){reservation.bike}
      let(:hook){reservation.hook}
      
      before :each do
        delete :destroy, :id => reservation
      end

      it "removes the reservation record" do
        expect(HookReservation.where{id =my{reservation.id}}.first).to be_nil
      end

      it "removes the hook from the bike" do
        expect(bike.hook).to be_nil
      end

      it "removes the bike from the hook" do
        expect(hook.bike).to be_nil
      end
      
    end

    context "when an unknown reservation is specified" do
      before :each do
        delete :destroy, :id => 0
      end

      it "redirects" do
        expect(response).to be_redirect
      end
    end
  end # describe "DELETE destroy"


  describe "GET 'new'" do
    
    before :each do
      get :new
    end
    
    it "Renders a hook reservation form" do
      expect(response).to render_template(:new)
    end

  end
  
  describe "Post 'Create'" do
    context "via form" do
      
      context "with array of trades given"

      context "with array of assignments given"

      context "with array of trades and assignments given"

    end
  end


  describe "PUT update" do

    context "when a present bike goes missing" do
      it "changes bike_state"
    end # context "when a found bike goes missing"

    context "when a missing bike is found" do
      it "changes the bike state"
    end # context "when a bike is found"

    context "when a present bike is found" do
      it "does not change bike state"
    end # context "when a present bike is found"

    context "when a missing bike is lost" do
      it "does not change the bike state"
    end # context "when a missing bike is lost"
    
    context "when a resolved hook has a conflict" do
      it "changes the hook state"
    end # context "when a hook has a conflict"
    
    context "when an unresolved hook has a conflict" do
      it "does not change hook state"
    end # context "when an unresolved hook has a conflict"
    
    context "when a hook with a conflict" do
      describe "is resolved" do
        it "changes the hook state"
      end
    end # context "when a hook with a conflict"

    context "the bike is lost and hook has conflict" do
    end # context "the bike is lost and hook has conflict"

    context "the bike is found and hook resolved" do
    end # context "the bike is found and hook resolved"

    context "the bike is lost and hook is resolved" do
    end #context "the bike is lost and hook is resolved"

    context "the bike is found and the hook has conflict" do
    end # context "the bike is found and the hook has conflict"

  end # describe "PUT update"

end
