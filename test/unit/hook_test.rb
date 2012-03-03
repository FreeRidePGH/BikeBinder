# == Schema Information
#
# Table name: hooks
#
#  id          :integer         not null, primary key
#  number      :integer
#  created_at  :datetime
#  updated_at  :datetime
#  bike_id     :integer
#  bike_number :integer
#

require 'test_helper'

class HookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
