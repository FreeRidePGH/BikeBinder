require 'spec_helper'

describe HooksController do

  #render_views

  describe "Get 'show'" do
    it "should be successful" do
      @hook = FactoryGirl.create(:hook)
      put 'show', :id => @hook
      response.should be_success
    end
  end

end
