require 'spec_helper'

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
  end

  it "redirects to index" do
    put 'index' do
      expect(response).to redirect_to root_path
    end
  end

  describe "Get 'show'" do

    context "with a valid hook" do
      subject(:hook){FactoryGirl.create(:hook)}
      
      it "is successful" do
        put 'show', :id => hook
        response.should be_success
      end
    end # context "with a valid hook"

    context "without a hook" do

      it "redirects" do
        put 'show', :id => 'test'
        expect(response).to redirect_to root_path
        # expect(response).to_not be_success
      end
    end

  end

end
