require 'spec_helper'

describe HookReservationsController do

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

  describe "DELETE destroy" do
    
  end
  
  describe "GET change" do
    
  end

  describe "PUT update" do

  end
end
