require 'spec_helper'

describe "Showing a bike", :type => :feature do
  context "with an available hook and assignment" do
    let(:program){FactoryGirl.create(:program)}
    let(:hook){FactoryGirl.create(:hook)}

    before :each do
      program
      hook
    end
    
    context "that is new" do
      let(:bike){FactoryGirl.create(:bike)}
      before :each do
        visit bike_path(bike)
      end
      
      it "lists the bike number" do
        expect(page).to have_text bike.number
      end
      
      it "has a form to reserve a hook" do
        expect(page).to have_button I18n.translate('commit_btn.new_hook_reservation')
      end

      describe "reserving the hook" do
        before :each do
          visit bike_path(bike)
          click_button I18n.translate('commit_btn.new_hook_reservation')
          bike.reload
        end        
        
        it "assigns the hook to the bike" do
          expect(bike.hook).to_not be_nil
        end
      end
    end #  context "that is new"
    
    context "with a hook" do
      let(:reservation){FactoryGirl.create(:hook_reservation)}
      let(:bike){reservation.bike}
      before :each do
        visit bike_path(bike)
      end
      
      it "lists the bike number" do
        expect(page).to have_text bike.number
      end

      it "has a form to free the hook" do
        expect(page).to have_button I18n.translate('commit_btn.delete_hook_reservation')
      end

      describe "freeing the hook" do
        before :each do
          visit bike_path(bike)
          click_button I18n.translate('commit_btn.delete_hook_reservation')
          bike.reload
        end
        it "removes the hook from the bike" do
          expect(bike.hook).to be_nil
        end
      end
    end #  context "with a hook"
    
    context "not departed with an assigned program" do
      let(:assignment){FactoryGirl.create(:assignment)}
      let(:bike){assignment.bike}
      before :each do
        visit bike_path(bike)
      end
      
      it "lists the bike number" do
        expect(page).to have_text bike.number
      end
    end # context "not departed with an assigned program"
    
    context "when departed with assigned program" do
      let(:assignment){FactoryGirl.create(:assignment_departed_prog)}
      let(:bike){assignment.bike}
      before :each do
        visit bike_path(bike)
      end
      
      it "lists the bike number" do
        expect(page).to have_text bike.number
      end
    end # context "when departed with assigned program"

    context "when departed with assigned destination" do
      let(:assignment){FactoryGirl.create(:assignment_departed_dest)}
      let(:bike){assignment.bike}
      before :each do
        visit bike_path(bike)
      end
      it "lists the bike number" do
        expect(page).to have_text bike.number
      end
    end # context "when departed with assigned destination"
  end # context "with an available hook and program defined"
end
