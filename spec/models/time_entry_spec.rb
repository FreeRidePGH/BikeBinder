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
# == Schema Information
#
# Table name: time_entries
#
#  id                  :integer         not null, primary key
#  time_trackable_id   :integer         default(0)
#  time_trackable_type :string(255)     default("")
#  title               :string(255)     default("")
#  description         :text            default("")
#  context_type        :string(255)     default("")
#  context_id          :integer         default(0)
#  user_id             :integer         default(0), not null
#  parent_id           :integer
#  lft                 :integer
#  rgt                 :integer
#  started_on          :datetime        not null
#  ended_on            :datetime        not null
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

