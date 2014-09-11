require 'spec_helper'

describe "Top level URI search", :type => :feature do
  context "with at least 2 bikes created" do
    let!(:bike_a){FactoryGirl.create(:bike)}
    let!(:bike_b){FactoryGirl.create(:bike)}
    
    describe "visiting the url for the bike #" do
      before :each do
        visit "/#{bike_a.number}"      
      end
      it "shows the bike content" do 
        expect(page).to have_content bike_a.number
      end # it "shows the bike content"

      it "does not show content for a different bike" do
        expect(page).to_not have_content bike_b.number
      end
    end # describe "visiting the url for the bike #"
  end # context "with at least 1 bike and hook created" 

  context "with at least 2 hooks created" do
    let!(:hook_a){FactoryGirl.create(:hook)}
    let!(:hook_b){FactoryGirl.create(:hook)}

    describe "visiting the url for the hook #" do
      before :each do
        visit "/#{hook_a.number}"      
      end

      it "shows the hook content" do 
        expect(page).to have_content hook_a.number
      end # it "shows the bike content"

      it "does not show content for a different hook" do
        expect(page).to_not have_content hook_b.number
      end
      
    end # describe "visiting the url for the hook #"
  end # context "with at least 2 hooks created"
  
end
