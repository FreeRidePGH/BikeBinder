require 'spec_helper'

describe "Visit Pages", :type => :feature do
  context "signed in as volunteer" do
    let(:user){FactoryGirl.create(:volunteer_user)}
    before :each do
      visit new_user_session_path
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => user.password
      click_button 'commit'
    end

    I18n.translate('page_link').each do |page_key, text|
      describe "visiting help pages" do
        before :each do
          visit page_path(page_key)
        end

        it "is loads the page successfully" do
          expect(page).to have_content text.titleize
        end
      end # describe "visiting help pages"
    end # ('page_link').each
    
  end # context "Signed in as a volunteer"
end # describe "Visit Pages"
