require 'spec_helper'

describe AssignmentsController do

  # POST is the ASSIGN action
  describe "POST 'create'" do

    context "with an unknown bike" do
      let(:bike){FactoryGirl.create(:bike)}
      let(:program){0}
      
      before :each do
        post :create, :bike_id => bike, :program_id => program
      end
      
      it "redirects to root" do
        expect(response).to redirect_to('/')
      end
    end # context "with an unknown bike"

    context "with an unknown program" do
      let(:bike){0}
      let(:program){FactoryGirl.create(:program)}
      
      before :each do
        post :create, :bike_id => bike, :program_id => program
      end
      
      it "redirects to root" do
        expect(response).to redirect_to('/')
      end
    end # context "with an unknown program"

    context "with valid bike and program" do
      let(:bike){FactoryGirl.create(:bike)}
      let(:program){FactoryGirl.create(:program)}
      
      before :each do
        post :create, :bike_id => bike, :program_id => program
      end
      
      it "redirects to the bike" do
        expect(response).to redirect_to(bike)
      end

      it "assigns the bike" do
        expect(bike.assignment).to_not be_nil
      end

      it "makes the bike unavailable" do
        expect(bike).to_not be_available
      end
    end # context "with valid bike and program"

    
    context "with already assigned bike and a different program" do
      let(:pre_assignment){FactoryGirl.create(:assignment)}
      let(:bike){pre_assignment.bike}
      let(:program){FactoryGirl.create(:program)}
      
      before :each do
        post :create, :bike_id => bike, :program_id => program
        bike.reload
      end
      
      it "redirects to the bike" do
        expect(response).to redirect_to(bike)
      end
      
      it "does not change the bike assignment" do
        expect(bike.assignment).to eq pre_assignment
        expect(pre_assignment.bike).to eq bike
      end

      it "does not assign the bike to the program" do
        expect(bike.application).to_not eq program
      end
      
    end # context "with already assigned bike and a different program"

    context "with bike already assigned to the given program" do
      let(:pre_assignment){FactoryGirl.create(:assignment)}
      let(:bike){pre_assignment.bike}
      let(:program){pre_assignment.application}
      
      before :each do
        post :create, :bike_id => bike, :program_id => program
        bike.reload
      end

      it "redirects to the bike" do
        expect(response).to redirect_to(bike)
      end

      it "does not create a new assignment" do
        expect(bike.assignment).to eq pre_assignment
      end

      it "keeps the bike assigned to the program" do
        expect(bike.application).to eq program
      end

    end # context "with bike already assigned to te given program"

  end # describe "POST 'create'"

  # DELETE is the CANCEL action
  describe "DELETE 'destroy'" do
    context "with a valid assignment" do
      subject(:assignment){FactoryGirl.create(:assignment)}
      let(:bike){assignment.bike}
      
      before :each do
        delete :destroy, :id => bike.assignment
        bike.reload
      end

      it "redirects to the bike" do
        expect(response).to redirect_to(bike)
      end
      
      it "makes the bike available" do
        expect(bike).to be_available
      end

      it "deletes the assignment" do
        expect(Assignment.where{id=my{assignment.id}}.first).to be_nil
      end
    end

    context "with an unknown assignment" do
      subject(:assignment){0}

      before :each do
        delete :destroy, :id => assignment
      end
      
      it "redirects to root" do
        expect(response).to redirect_to('/')
      end
    end

    context "with a departed, assigned, bike" do
      subject(:assignment){FactoryGirl.create(:assignment_departed_prog)}
      let(:bike){assignment.bike}
      
      before :each do
        delete :destroy, :id => bike.assignment
        bike.reload
      end

      it "redirects to the bike" do
        expect(response).to redirect_to(bike)
      end

      it "has a departed bike" do
        expect(bike).to be_departed
      end

      it "keeps the bike assigned" do
        expect(bike).to_not be_available
      end

      it "does not cancel the assignment" do
        expect(bike.assignment).to eq assignment
      end
    end
    
  end # describe "DELETE 'destroy'"
  
end # describe AssignmentsController
