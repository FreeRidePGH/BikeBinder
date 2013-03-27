require 'spec_helper'

# Case the project is done, but not closed:
#   Confirmation to close the project (FINISH project)
#   Note: a project is done but not closed if it meets all
#   project requirements, but it has just not been closed yet
#
# Case the project is not done, render page with options:
#   Go to project to finish it (SHOW project) 
#   - or -
#   Close anyway (FINISH project)
#
# Case there is no project:
#   Options & form to start a new project (render page with depart form)
#
# Case the bike is already departed:
#   Notify error (SHOW bike)
#
describe DeparturesController do

  # POST is the DEPART action
  describe "POST 'create'" do

    context "with an unassigned bike and unknown destination" do
      let(:bike){FactoryGirl.create(:bike)}
      let(:destination){0}
      
      before :each do
        post :create, :bike_id => bike, :destination_id => destination
      end
      
      # In this case, the depart page gives the user the chance
      # to select a destination or assign to a program
      it "redirects to the depart page" do
        expect(response).to redirect_to(new_bike_departure_path(bike))
      end
    end # context "with an unknown destination"

    context "with an unknown bike" do
      let(:bike){0}
      let(:destination){FactoryGirl.create(:destination)}
      
      before :each do
        post :create, :bike_id => bike, :destination_id => destination
      end
      
      it "redirects to root" do
        expect(response).to redirect_to('/')
      end
    end # context "with an unknown bike"

    context "with a valid bike that is assigned" 

    context "with valid bike and destination" do
      let(:bike){FactoryGirl.create(:bike)}
      let(:destination){FactoryGirl.create(:destination)}
      
      before :each do
        post :create, :bike_id => bike, :destination_id => destination.id, :value => 99
        bike.reload
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

      it "departs the bike" do
        expect(bike).to be_departed
      end
    end # context "with valid bike and program"

    context "with an already departed bike"
    
    context "with already assigned bike and a given destination" do
      let(:pre_assignment){FactoryGirl.create(:assignment)}
      let(:bike){pre_assignment.bike}
      let(:dest){FactoryGirl.create(:destination)}
      
      before :each do
        post :create, :bike_id => bike, :destination_id => dest, :value => 0
        bike.reload
      end
      
      it "redirects to the bike" do
        expect(response).to redirect_to(bike)
      end
      
      it "does not assign the bike assigment to the departure method" do
        expect(bike.application.method).to eq pre_assignment.application
        expect(pre_assignment.bike).to eq bike
      end

      it "does not assign the bike to the destination" do
        expect(bike.application.method).to_not eq dest
      end
      
    end # context "with already assigned bike and a given destination"

    context "with an already departed bike and a given destination" do
      let(:prior_assignment){FactoryGirl.create(:assignment_departed_dest)}
      let(:bike){prior_assignment.bike}
      let(:destination){FactoryGirl.create(:destination)}
      
      before :each do
        post :create, :bike_id => bike, :destination_id => destination, :value => 0
        bike.reload
      end

      it "redirects to the bike" do
        expect(response).to redirect_to(bike)
      end

      it "does not create a new assignment" do
        expect(bike.assignment).to eq prior_assignment
      end

      it "keeps the bike assigned to the departure" do
        expect(bike.application).to eq prior_assignment.application
      end
    end # context "with an already departed bike and a given destination"

  end # describe "POST 'create'"

  # DELETE is the RETURN action
  describe "DELETE 'destroy'" do
    context "with a program assigned" do
      subject(:departure){FactoryGirl.create(:assignment_departed_prog).application}
      let(:bike){departure.bike}
      let(:program){departure.application}
      
      before :each do
        program
        delete :destroy, :id => bike.assignment
        bike.reload
      end

      it "redirects to the bike" do
        expect(response).to redirect_to(bike)
      end
      
      it "keeps the bike unavailable" do
        expect(bike).to_not be_available
      end

      it "returns the bike" do
        expect(bike).to_not be_departed
      end

      it "keeps the assignment" do
        expect(Assignment.where{bike_id=my{bike.id}}.first).to_not be_nil
        expect(bike.assignment).to_not be_nil
      end

      it "references program directly to the assignment" do
        expect(bike.application).to eq program
      end 
    end # context "with a program assigned"

    context "with a destination assigned" do
      subject(:departure){FactoryGirl.create(:assignment_departed_dest).application}
      let(:bike){departure.bike}
      let(:destination){departure.application}
      
      before :each do
        destination
        delete :destroy, :id => bike.assignment
        bike.reload
      end

      it "redirects to the bike" do
        expect(response).to redirect_to(bike)
      end
      
      it "makes the bike available" do
        expect(bike).to be_available
      end

      it "returns the bike" do
        expect(bike).to_not be_departed
      end

      it "removes the assignment" do
        expect(Assignment.where{bike_id=my{bike.id}}.first).to be_nil
        expect(bike.assignment).to be_nil
      end

    end # context "with a destination assigned"

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

      it "has a non-departed bike" do
        expect(bike).to_not be_departed
      end

      it "keeps the bike assigned" do
        expect(bike).to_not be_available
      end

      it "does not cancel the assignment" do
        expect(bike.assignment).to eq assignment
      end
    end # context "with a departed, assigned, bike"
    
  end # describe "DELETE 'destroy'"

end # describe DeparturesController

