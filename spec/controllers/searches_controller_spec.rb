require 'rails_helper'

describe SearchesController do
  let(:user){FactoryGirl.create(:volunteer_user)}

  describe "GET 'index'" do

    before :each do
      # sign_out :user
      sign_in user
    end

    context "with exact bike number search term match" do
      let(:bike){FactoryGirl.create(:bike)}

      before :each do
        get 'index', :q => bike.number
      end

      it "exposes the correct bike" do
        expect(controller.bike).to_not be_nil
        expect(controller.bike.id).to eq(bike.id)
      end
    end # context "exact bike number match"
    
    context "with garbage search term" do
      let(:term){'qwerty'}
      let(:err_msg){I18n.translate('controller.searches.index.fail', :term => term)}

      before :each do 
        get 'index', :q => term
      end
      
      it "indicates a failed search" do
        expect(controller.flash[:error]).to eq err_msg
      end
    end # describe "garbage search term"
    
    context "with exact hook search term match" do
      context "on reserved hook" do
        let(:reservation){FactoryGirl.create(:hook_reservation)}
        let(:hook){reservation.hook}
        let(:bike){reservation.bike}

        before :each do 
          get 'index', :q => hook.number
        end

        it "redirects to the bike" do
          expect(response).to redirect_to(bike)
        end
        
        it "exposes the correct bike" do
          expect(controller.bike).to_not be_nil
          expect(controller.bike.id).to eq(bike.id)
        end
      end
      
      context "on unreserved hook" do
        let(:hook){FactoryGirl.create(:hook)}

        before :each do 
          get 'index', :q => hook.number
        end
        
        it "redirects to the hook" do
          expect(response).to redirect_to(hook)
        end
      end # context "on unreserved hook"
    end # context "exact hook match"

    context "with formatted but unmatching hook number term" do
      let(:term){FactoryGirl.generate(:hook_number)}
      let(:err_msg){I18n.translate('controller.searches.index.fail', :term => term)}

      before :each do 
        get 'index', :q => term
      end

      it "indicates a failed search" do
        expect(controller.flash[:error]).to eq err_msg
      end
    end # context "with formatted but unmatching bike number term"

    context "with formatted but unmatching bike number term" do
      let(:term){FactoryGirl.generate(:bike_number)}
      let(:err_msg){I18n.translate('controller.searches.index.fail', :term => term)}
      
      before :each do 
        get 'index', :q => term
      end

      it "indicates a failed search" do
        expect(controller.flash[:error]).to eq err_msg
      end
    end # context "with formatted but unmatching bike number term"

  end # desctibe "GET 'index'"
end # describe SearchesController
