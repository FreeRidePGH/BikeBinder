require 'spec_helper'

describe User do

  before(:each) do
    @user = FactoryGirl.build(:user)
  end

  it "Should have an id" do
    @user.should_not be_nil
    @user.save
    puts @user.errors.messages if @user.id.nil?
    @user.id.should_not be_nil
  end

  it "Should have a group" do
    @user.group.should_not be_nil
  end

  context "volunteer" do
    before(:each) do
      @user = FactoryGirl.build(:volunteer_user)
    end
    it "Should have group volunteer" do
      @user.should be_volunteer
    end
  end

end

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

