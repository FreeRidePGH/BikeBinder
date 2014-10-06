require 'spec_helper'
include Devise::TestHelpers

describe HookReservationsController do
  let(:sig){"ABC"}
  let(:user){FactoryGirl.create(:staff_user)}
  
  describe "GET new" do
    context "when signed in" do
      before :each do
        sign_in user
      end
      
      it "should be successful", :if => false do
        get :new
        expect(response).to be_success
      end
    end
  end
  
  # POST is the RESERVE action
  describe "POST 'create'" do

    context "without a signatory" do
      let(:bike){FactoryGirl.create(:bike)}
      let(:hook){FactoryGirl.create(:hook)}
      
      before :each do
        sign_in user        
        post :create, :bike_id => bike, :hook_id => hook, :sig => nil
      end

      it "redirects to the bike" do
        expect(response).to redirect_to(bike)
      end      

      it "does not reserve the hook" do
        expect(bike.hook).to be_nil
      end
      
      it "does not assign the bike" do
        expect(hook.bike).to be_nil
      end
    end # context "without a signatory"

    context "when signed in" do

      before :each do
        sign_in user
      end

      context "with valid bike and hook" do
        let(:bike){FactoryGirl.create(:bike)}
        let(:hook){FactoryGirl.create(:hook)}
        
        before :each do
          post :create, :bike_id => bike, :hook_id => hook, :sig => sig
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
          post :create, :bike_id => parked_bike, :hook_id => hook, :sig => sig
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
          post :create, :bike_id => bike, :hook_id => hook, :sig => sig
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
          post :create, :bike_id => bike, :hook_id => hook, :sig => sig
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
          post :create, :bike_id => bike, :hook_id => hook, :sig => sig
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

    end # context "with signed in user"

  end # describe "POST 'create'"


  # DELETE is the VACATE action
  describe "DELETE destroy" do
    context "without a signatory" do
      subject(:reservation){FactoryGirl.create(:hook_reservation)}
      let(:bike){reservation.bike}
      let(:hook){reservation.hook}
      
      before :each do
        sign_in user
        delete :destroy, :id => reservation, :sig => nil
      end

      it "removes the hook from theh bike" do
        expect(bike.hook).to eq hook
      end

      it "keeps the bike on the hook" do
        expect(hook.bike).to eq bike
      end
      
    end # context "without a signatory"

    context "when signed in" do

      before :each do
        sign_in user
      end
      
      context "when a given reservation is found" do
        subject(:reservation){FactoryGirl.create(:hook_reservation)}
        let(:bike){reservation.bike}
        let(:hook){reservation.hook}
        
        before :each do
          delete :destroy, :id => reservation, :sig => sig
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
          delete :destroy, :id => 0, :sig => sig
        end
        
        it "redirects" do
          expect(response).to be_redirect
        end
      end
    end # context "when signed in"
  end # describe "DELETE destroy"

  describe "Post 'Create'" do
    context "when signed in" do

      before :each do
        sign_in user
      end
      
      context "via form" do
      
      context "with array of trades given"

      context "with array of assignments given"

      context "with array of trades and assignments given"

      end # context "via form"
    end #     context "when signed in"
  end

  describe "PUT update" do
    subject(:reservation){FactoryGirl.create(:hook_reservation)}

    context "without a signatory" do
      it "does not change state" do
        reservation.find_bike
        expect{
          sign_out :user
          put :update, :id => reservation, :bike_event => :lose, :sig => nil
        }.to_not change{reservation.reload.bike_state+reservation.hook_state}
      end
    end # context "without a signatory"

    context "when signed in" do

      before :each do
        sign_in user
      end
      
      context "with a new reservation" do
        context "given garbage state" do
          it "does not change state" do
            expect{
            put :update, :id => reservation, :garbage_event => :lose, :sig => sig
            }.to_not change{reservation.reload.bike_state+reservation.hook_state}
          end
        end
      
        context "given garbage action for bike state" do
          it "does not change state" do
            expect{
              put :update, :id => reservation, :bike_event => :garbage, :sig => sig
          }.to_not change{reservation.reload.bike_state+reservation.hook_state}
          end
        end
        
        context "given garbage action for hook_state" do
          it "does not change state" do
            expect{
            put :update, :id => reservation, :hook_event => :garbage, :sig => sig
            }.to_not change{reservation.reload.bike_state+reservation.hook_state}
          end
        end
        context "given garbage action for hook_state and bike_state" do
          it "does not change state" do
            expect{
              put :update, :id => reservation, 
            :hook_event => :garbage, :bike_event => :garbage, :sig => sig
            }.to_not change{reservation.reload.bike_state+reservation.hook_state}
          end
        end
      end
      
      context "when a present bike goes missing" do
        before :each do
          reservation.find_bike
          put :update, :id => reservation, :bike_event => :lose, :sig => sig
          reservation.reload
        end
        
        it "is valid" do
          expect(reservation).to be_valid
        end
        
        it "redirects to the bike" do
          expect(response).to redirect_to reservation.bike
        end
        
        it "changes bike_state to missing" do
          expect(reservation.bike_state).to eq 'missing'
      end
      end # context "when a found bike goes missing"

      context "when a missing bike is found" do
        before :each do
          reservation.lose_bike
          put :update, :id => reservation, :bike_event => :find, :sig => sig
          reservation.reload
        end
        
        it "changes bike_state to present" do
          expect(reservation.bike_state).to eq 'present'
        end
        
        it "redirects to the bike" do
          expect(response).to redirect_to reservation.bike
        end
      end # context "when a bike is found"
      
      context "when a present bike is found" do
        before :each do
          reservation.find_bike
          put :update, :id => reservation, :bike_event => :find
          reservation.reload
        end
        
        it "keeps the bike_state as present" do
          expect(reservation.bike_state).to eq 'present'
        end
      end # context "when a present bike is found"
      
      context "when a missing bike is lost" do
        before :each do
          reservation.lose_bike
          put :update, :id => reservation, :bike_event => :lose, :sig => sig
          reservation.reload
        end
        
        it "keeps the bike_state as missing" do
          expect(reservation.bike_state).to eq 'missing'
        end
      end # context "when a missing bike is lost"
      
      context "when a resolved hook has a conflict" do
        before :each do
          reservation.resolve_hook
          put :update, :id => reservation, :hook_event => :raise_issue, :sig => sig
          reservation.reload
        end
        
        it "changes the hook state to unresolved" do
          expect(reservation.hook_state).to eq "unresolved"
        end
      end # context "when a hook has a conflict"
      
      context "when an unresolved hook has a conflict" do
        before :each do
        reservation.raise_issue_hook
          put :update, :id => reservation, :hook_event => :raise_issue, :sig => sig
          reservation.reload
        end
        
        it "keeps the hook state to unresolved" do
          expect(reservation.hook_state).to eq "unresolved"
        end
      end # context "when an unresolved hook has a conflict"
      
      context "when a hook with a conflict" do
        describe "is resolved" do
          before :each do
            reservation.raise_issue_hook
            put :update, :id => reservation, :hook_event => :resolve, :sig => sig
            reservation.reload
          end
          
          it "changes the hook state to resolved" do
            expect(reservation.hook_state).to eq "resolved"
          end
        end
      end # context "when a hook with a conflict"
      
      context "when the bike is missing and hook is unresolved" do
        describe "the bike is found and the hook issue is resolved" do
          before :each do
            reservation.raise_issue_hook
            reservation.lose_bike
            put :update, :id => reservation, 
            :bike_event => :find, :hook_event => :resolve, :sig => sig
            
            reservation.reload
          end
          
          it "changes the hook state to resolved" do
            expect(reservation.hook_state).to eq "resolved"          
          end
          it "changes bike_state to present" do
            expect(reservation.bike_state).to eq 'present'
          end
        end      
      end # context "when the bike is missing and hook is unresolved" do
      
      context "the bike is present and hook resolved" do
        describe "the bike is lost and the hook has issues" do
          before :each do
            reservation.find_bike
            reservation.resolve_hook
            put :update, :id => reservation, 
            :bike_event => :lose, :hook_event => :raise_issue, :sig => sig
            reservation.reload
          end
          
          it "changes the hook state to unresolved" do
            expect(reservation.hook_state).to eq "unresolved"
          end
          it "changes bike_state to missing" do
            expect(reservation.bike_state).to eq 'missing'
          end
        end
      end # context "the bike is found and hook resolved"

    end # context "when signed in"
  end # describe "PUT update"

end # describe HookReservationsController
