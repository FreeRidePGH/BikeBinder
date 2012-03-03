# == Schema Information
#
# Table name: bikes
#
#  id               :integer         not null, primary key
#  color            :string(255)
#  value            :float
#  seat_tube_height :float
#  top_tube_length  :float
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class BikesTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
