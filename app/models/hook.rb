require 'hook_number'
require 'number_slug'

class Hook < ActiveRecord::Base

  #############
  # Attributes

  extend FriendlyId
  extend NumberSlug

  friendly_id :slug
  number_slug :prefix => 'location', :delimiter => '-'

  # Override with value object
  def number
    HookNumber.new(number_record)
  end
  def number=(val)
    self.send('number_record=', val)
  end

  ##############
  # Associations

  has_one :reservation, :class_name => "HookReservation", :dependent => :destroy
  has_one :bike, :through => :reservation

  hound

  #######################
  # Properties and Scopes

  def available?
    !!reservation.nil?
  end

  def self.reserved
    return Hook.joins{:reservation}.where{reservation.hook_id != nil}
  end
  
  def self.available
    Hook.where{id.not_in(my{self.reserved}.select{id})}
  end
  
  # May want to select available condinionally on the bike
  # or bike relations, like projects
  # For example, FFS projects may have a certain set of 
  # hooks reserved only for FFS.
  def self.next_available(bike=nil)
    self.available.first
  end

  def self.simple_search(search)
    hooks = Hook.where("number LIKE ?","%#{search}%")
    return hooks
  end

  #############
  # Validations

  validates :number_record, :uniqueness => true, :allow_nil => false
  validates :number_record, :hook_number => true

end
