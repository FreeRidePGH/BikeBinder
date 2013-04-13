require 'spec_helper'

describe ProgramsController do

  describe "GET 'index'", :if => false do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

end
