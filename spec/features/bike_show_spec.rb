require 'spec_helper'

describe "Showing a bike", :type => :feature do

  let(:bike){FactoryGirl.create(:bike)}
  
  it "lists the bike number" do
    visit bike_path(bike)
    expect(page).to have_text bike.number
  end
  
  context "with an available program" do
    let!(:program){FactoryGirl.create(:program)}
    
    before :each do
      visit bike_path(bike)
    end
    
    it "has a form to assign to a program" do
      expect(page).to have_button I18n.translate('commit_btn.new_assignment')      
    end
  end
    
  context "with an available hook" do
    let!(:hook){FactoryGirl.create(:hook)}
    before :each do
      visit bike_path(bike)
    end
    
    context "no current reservation" do
      it "has a form to reserve a hook" do
        expect(page).to have_button I18n.translate('commit_btn.new_hook_reservation')
      end
    end
  end # context "with an available hook"

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

    it "does not have a form to reserve a hook" do
      expect(page).to_not have_button I18n.translate('commit_btn.new_hook_reservation')
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
end
