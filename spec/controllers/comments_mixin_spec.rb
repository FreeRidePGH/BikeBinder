require 'spec_helper'
include Devise::TestHelpers

describe BikesController do
  let(:sig){nil}
  let(:user){FactoryGirl.create(:staff_user)}
  let(:commentable){FactoryGirl.create(:bike)}
  let(:comment){ {:body => "TEST"} }

  describe "posting a comment" do
    context "when not signed in" do
      before(:each) do
        sign_out :user
        post :new_comment, :comment => comment, :id => commentable, :sig => sig
      end

      it "is does not have a comment" do
        expect(controller.comment).to be_nil
      end

      it "is has a commentable" do
        expect(controller.commentable).to_not be_nil
      end

      it "does not redirect to root" do
        expect(response).to_not redirect_to(root_path)
      end
    end # context "when not signed in"

    context "when signed in" do
      before(:each) do
        sign_in user
        post :new_comment, :comment => comment, :id => commentable, :sig => sig
      end

      it "is saves the comment" do
        expect(controller.comment).to be_persisted
      end

      it "redirects to the commentable" do
        expect(response).to redirect_to(:id=>commentable, :action=>:show)
      end
      
    end # context "when signed in"
  end # describe "posting a comment"
end # describe ExampleTestController
