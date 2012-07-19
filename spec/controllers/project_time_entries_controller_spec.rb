require 'spec_helper'

describe ProjectTimeEntriesController do
  include Devise::TestHelpers

  before(:each) do
    @proj||=Project.all.first
    unless @proj
      d = FactoryGirl.build(:youth_detail)
      @proj = d.proj
      @proj.detail = d
    end

    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it "should be successful"
      # get 'index'
      # response.should be_success
  end

  describe "GET 'show'" do
    it "should be successful"
      #get :show, {:bike_id => @proj.bike.number}
      #response.should be_success

    it "should be valid" 
      # get :show, {:bike_id => @proj.bike.number}
      # response.time_entry.should be_valid
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new, {:project_id => @proj}
      response.should be_success
    end

    it "should have a current user" do
      subject.current_user.should_not be_nil
    end

    it "should be valid" do
      # to sign in a user see:
      # http://eureka.ykyuen.info/2011/03/04/rails-rspec-test-with-devise/
      # https://github.com/plataformatec/devise/wiki/How-To:-Controllers-and-Views-tests-with-Rails-3-(and-rspec)
      # http://stackoverflow.com/questions/9508707/rail3-rspec-devise-rspec-controller-test-fails-unless-i-add-a-dummy-subject-cur
      get :new, {:project_id => @proj}

      user = subject.current_user

      e = controller.time_entry
      e.should_not be_nil

      e.user.should_not be_nil

      puts "Ended: #{e.ended_on}"
      puts "Started: #{e.started_on}"

      puts "Id:  #{e.id}"
      puts "Obj Id:  #{e.time_trackable.id}"
      puts "Obj type:  #{e.time_trackable_type}"
      puts "Desc blank?:  #{e.description.blank?}"
            
      puts "Current user nil?:  #{controller.current_user.nil?}"
      
      e.started_on.should_not be_nil
      e.ended_on.should_not be_nil
      e.should be_valid
    end
  end

  describe "POST 'hours/enter'" do
    it "should add a new entry" do
      # Testing nested resources
      # http://stackoverflow.com/questions/8047052/testing-nested-controller-action-with-rspec

      post :create, :project_id => @proj
      response.should redirect_to(project_path(@proj))
    end
  end

end
