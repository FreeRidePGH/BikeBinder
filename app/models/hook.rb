# == Schema Information
#
# Table name: hooks
#
#  id         :integer         not null, primary key
#  number     :integer
#  created_at :datetime
#  updated_at :datetime
#  bike_id    :integer
#

class Hook < ActiveRecord::Base
  attr_accessible :number

  validates_presence_of :number
  validates_uniqueness_of :number

  belongs_to :bike, :inverse_of=>:hook

  # May want to select available condinionally on the bike
  # or bike relations, like projects
  def self.next_available(bike=nil)
    return Hook.find_by_bike_id(nil)
  end
end
