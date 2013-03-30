require 'spec_helper'

describe "Action" do
  let(:bike){FactoryGirl.create(:bike)}

  describe "reserving an available hook" do
    let!(:hook){FactoryGirl.create(:hook)}

    context "with an available hook specified" do
      before :each do
        visit bike_path(bike)
        select hook.number, :from => :hook_id              
        click_button I18n.translate('commit_btn.new_hook_reservation')
        bike.reload
      end        
      
      it "assigns the hook to the bike" do
        expect(bike.hook).to_not be_nil
      end

      it "lists the bike number" do
        expect(page).to have_text bike.number
      end
    end # context "with an available hook specified"

    context "when no hook is specified" do
      before :each do
        visit bike_path(bike.reload)
        click_button I18n.translate('commit_btn.new_hook_reservation')
        bike.reload
      end
      
      it "does not assign a hook to the bike" do
        expect(bike.hook).to be_nil
      end
      
      it "does not depart the bike" do
        expect(bike).to_not be_departed
      end

      it "lists the bike number" do
        expect(page).to have_text bike.number
      end
    end # context "when no hook is specified"
  end # describe "reserving an available hook"

  describe "vacating a reserved hook" do
    let(:reservation){FactoryGirl.create(:hook_reservation)}
    let(:bike){reservation.bike}

    before :each do
      visit bike_path(bike)
      click_button I18n.translate('commit_btn.delete_hook_reservation')
      bike.reload
    end
    it "removes the hook from the bike" do
      expect(bike.hook).to be_nil
    end
    it "lists the bike number" do
      expect(page).to have_text bike.number
    end
  end # describe "vacating a reserved hook"
  
  describe "assigning to a program" do
    let!(:program){FactoryGirl.create(:program)}
    
    before :each do
      visit bike_path(bike)
      select program.label, :from => :program_id
      click_button I18n.translate('commit_btn.new_assignment')
    end
    
    it "makes the bike unavailable" do
      expect(bike).to_not be_available
    end
    
    it "assigns the bike to the program" do
      expect(bike.application).to eq program
    end

    it "lists the bike number" do
      expect(page).to have_text bike.number
    end
  end # describe "being assigned to a program"

  describe "canceling an assignment" do
    let(:assignment){FactoryGirl.create(:assignment)}
    let(:bike){assignment.bike}
    let!(:program){assignment.application}
    
    before :each do
      visit bike_path bike
      click_button I18n.translate('commit_btn.del_assignment')
    end
    
    it "removes the bike from the program" do
      expect(bike.application).to_not eq program
    end

    it "makes the bike available" do
      expect(bike.application).to be_nil
    end

    it "lists the bike number" do
      expect(page).to have_text bike.number
    end
  end
  
  describe "departing" do
    context "without an assignment" do
      before :each do
        visit bike_path bike
      end
      
      it "can specify destination" do
        expect(page).to have_select :destination_id
      end
      
      context "without speficifying destination" do
        before :each do
          visit bike_path bike
          click_button I18n.translate('commit_btn.new_departure')
        end
        
        it "does not depart the bike" do
          expect(bike).to_not be_departed
        end
        
        it "does not assign the bike" do
          expect(bike.application).to be_nil
        end

        it "lists the bike number" do
          expect(page).to have_text bike.number
        end

      end # context "without speficifying destination"
      
      context "with specifying destination" do
        let(:destination){FactoryGirl.create(:destination)}
        before :each do
          destination #make sure it is created before visiting the page
          visit bike_path bike
          select destination.label, :from => :destination_id              
          click_button I18n.translate('commit_btn.new_departure')
        end
        
        it "departs the bike" do
          expect(bike).to be_departed
        end
        
        it "assigns the bike to the destination" do
          expect(bike.application).to_not be_nil
          expect(bike.application.method).to eq destination
        end
        it "lists the bike number" do
          expect(page).to have_text bike.number
        end
      end # context "with specifying destination"
    end # context "without an assignment"
    
    context "with an assignment" do
      let (:assignment){FactoryGirl.create(:assignment)}
      subject(:assigned_bike){assignment.bike}
      
      before :each do
        visit bike_path assigned_bike
        click_button I18n.translate('commit_btn.new_departure')
      end
      it "departs the bike" do
        expect(assigned_bike).to be_departed
      end

      it "lists the bike number" do
        expect(page).to have_text assigned_bike.number
      end
    end # context "with an assignment"
  end # describe "departing"

  describe "returning" do

    context "when departed with assigned program" do
      let(:assignment){FactoryGirl.create(:assignment_departed_prog)}
      let(:assigned_bike){assignment.bike}

      before :each do
        visit bike_path assigned_bike
        click_button I18n.translate('commit_btn.del_departure')
      end

      it "lists the bike number" do
        expect(page).to have_text assigned_bike.number
      end

    end # context "when departed with assigned program"
    
    context "when departed with assigned destination" do
      let(:assignment){FactoryGirl.create(:assignment_departed_dest)}
      let(:assigned_bike){assignment.bike}

      before :each do
        visit bike_path assigned_bike
        click_button I18n.translate('commit_btn.del_departure')
      end

      it "lists the bike number" do
        expect(page).to have_text assigned_bike.number
      end
    end # context "when departed with assigned destination"

  end # describe "returning from departure"
end # describe "Action"
