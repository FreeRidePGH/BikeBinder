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

class Hook < ActiveRecord::Base
  attr_accessible :number

  validates_presence_of :number
  validates_uniqueness_of :number

  belongs_to :bike, :inverse_of=>:hook
end
