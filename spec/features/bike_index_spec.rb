require 'spec_helper'

describe "Bikes index", :type => :feature do
  context "as volunteer" do
    let(:user){FactoryGirl.create(:volunteer_user)}
    before :each do
      visit new_user_session_path
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => user.password
      click_button 'commit'
    end

    context "with at least 1 bike created" do
      let!(:bike_a){FactoryGirl.create(:bike)}
      let!(:bike_b){FactoryGirl.create(:bike)}
      
      it "shows bike content" do
        visit bikes_path 
        
        expect(page).to have_content bike_a.number
        expect(page).to have_content bike_a.color.name.capitalize
        
        expect(page).to have_content bike_b.number
        expect(page).to have_content bike_b.color.name.capitalize
      end
      
      context "with bike wit a program" do
        let(:assignment){FactoryGirl.create(:assignment)}
        let!(:assigned_bike){assignment.bike}
        
        before :each do
          visit bikes_path 
        end
        
        it "renders the bike list" do
          expect(page).to have_content bike_a.number
        end
      end
      
      context "with bike and a hook" do
        let(:reservation){FactoryGirl.create(:hook_reservation)}
        let!(:reserving_bike){reservation.bike}
        
        before :each do
          visit bikes_path 
        end
        
        it "renders the bike list" do
          expect(page).to have_content bike_a.number
        end
      end
      
    context "with departed bike" do
        let(:prog_departure){FactoryGirl.create(:departure_with_prog)}
        let(:dest_departure){FactoryGirl.create(:departure_with_dest)}      
        let!(:bike_dep_prog){prog_departure.bike}
        let!(:bike_dep_dest){dest_departure.bike}
        
        before :each do
          visit bikes_path 
        end
        
        it "renders the bike list" do
          expect(page).to have_content bike_a.number
        end
      end
      
    end   # context "with at least 1 bike created" do
  end # context as volunteer
end # describe "Bikes index"
