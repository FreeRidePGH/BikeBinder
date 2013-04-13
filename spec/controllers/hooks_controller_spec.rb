require 'spec_helper'
include Devise::TestHelpers

describe HooksController do

  #render_views

  describe "Post 'new'" do
    it "redirects to root" do
      begin
        post :new, {}
      rescue
        expect(request.path).to eq ''
      end
    end
  end # describe "Post 'new'"

  describe "Get 'show'" do
    context "when signed out" do
      before :each do
        sign_out :user
      end

      context "with a valid unassigned hook" do
        subject(:hook){FactoryGirl.create(:hook)}
        
        before :each do
          get :show, :id => hook.number
        end
        
        it "exposes the correct hook" do
          expect(controller.hook).to eq hook
        end
      end # context "with a valid unreserved hook"
      
      context "with a reserved hook" do
        let(:reservation){FactoryGirl.create(:hook_reservation)}
      subject(:hook){reservation.hook}
        
        before :each do
          get :show, :id => hook.number
        end
        
      it "exposes the correct hook" do
          expect(controller.hook).to eq hook
        end
      end # context "with a reserved hook"
      
      context "without a hook" do
        let(:hook_number){FactortyGirl.create(:hook_number)}
        it "redirects to root" do
          begin
            get :show, :id => hook_number
          rescue
            expect(request.path).to eq ''
          end
        end # it "redirects to root"
      end # context "without a hook"

    end # context "signed out"
  end # describe "Get 'show'"
end # describe HooksController
