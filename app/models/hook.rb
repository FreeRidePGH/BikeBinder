require 'hook_number'
require 'number_slug'

class Hook < ActiveRecord::Base
  extend FriendlyId
  extend NumberSlug

  friendly_id :slug
  number_slug :prefix => 'location', :delimiter => '-'

  attr_accessible :number

  has_one :reservation, :class_name => "HookReservation"
  has_one :bike, :through => :reservation

  scope :available, :conditions => {:hook_reservation_id => nil}

  # Override with value object
  def number
    HookNumber.new(super)
  end

  validates :number, :hook_number => true
  validates_uniqueness_of :number, :allow_nil => false

  # May want to select available condinionally on the bike
  # or bike relations, like projects
  # For example, FFS projects may have a certain set of 
  # hooks reserved only for FFS.
  def self.next_available(bike=nil)
    return Hook.where{bike_id == nil}.first
  end

  def self.simple_search(search)
    hooks = Hook.where("number LIKE ?","%#{search}%")
    return hooks
  end
end
