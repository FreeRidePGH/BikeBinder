require 'spec_helper'

describe TimeEntry do
  
  before(:each) do
    @user = User.all.first
    @user ||= FactoryGirl.create(:user)

    @proj = FactoryGirl.create(:youth_project)
  end

  it "should be built with default time and descriptions" do
    opts = {}
    # opts[:end] = Time.now
    # opts[:start] = Time.now
    opts[:description] = "TEST"
    opts[:obj] = @proj
    opts[:user_id] = @user.id

    e = TimeEntry.build_from(opts)
    e.should be_valid
    e.started_on.should_not be_nil
  end

end
