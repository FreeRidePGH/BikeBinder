require 'rails_helper'

RSpec.describe User, :type=>:model do
  let(:user){FactoryGirl.build(:user)}

  it "Should have an id" do
    expect(user).to_not be_nil
    user.save
    expect(user.id).to_not be_nil
  end

  it "Should have a group" do
    expect(user.group).to_not be_nil
  end

  context "volunteer", type: :model do
    let(:user){FactoryGirl.build(:volunteer_user)}
    it "Should have group volunteer" do
      expect(user).to be_volunteer
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

