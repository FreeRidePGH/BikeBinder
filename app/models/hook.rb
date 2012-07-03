# == Schema Information
#
# Table name: hooks
#
#  id         :integer         not null, primary key
#  number     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  bike_id    :integer
#

class Hook < ActiveRecord::Base
  extend FriendlyId
  friendly_id :label

  attr_accessible :number

  validates_presence_of :number
  validates_uniqueness_of :number

  belongs_to :bike, :inverse_of=>:hook

  scope :available, :conditions => {:bike_id => nil}

  def self.number_pattern
    return /\d{3}/
  end

  # May want to select available condinionally on the bike
  # or bike relations, like projects
  # For example, FFS projects may have a certain set of 
  # hooks reserved only for FFS.
  def self.next_available(bike=nil)
    return Hook.find_by_bike_id(nil)
  end

  def label
    "location-#{self.number}"
  end

  def self.id_from_label(label, delimiter='-')
    arr = label.split(delimiter) if label
    arr[-1] if arr
  end

  def self.find_by_label(label, delimiter='-')
    id = Hook.id_from_label(label, delimiter)
    Hook.find_by_number(id)
  end
end
