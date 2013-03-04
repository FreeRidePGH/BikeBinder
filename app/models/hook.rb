require 'hook_number'

class Hook < ActiveRecord::Base
  extend FriendlyId
  friendly_id :label

  attr_accessible :number

  belongs_to :bike, :inverse_of => :hook

  scope :available, :conditions => {:bike_id => nil}

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

  def label
    "location-#{self.number}"
  end

  def self.id_from_label(label, delimiter='-')
    arr = label.split(delimiter) if label
    arr[-1] if arr
  end

  def self.find_by_label(label, delimiter='-')
    id = Hook.id_from_label(label, delimiter)
    Hook.where{number == my{id}}.first
  end

  def self.simple_search(search)
    hooks = Hook.where("number LIKE ?","%#{search}%")
    return hooks
  end
end
