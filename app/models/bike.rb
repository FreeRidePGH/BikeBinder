require "has_one_soft_delete"
require 'bike_mfg'
require 'color_name-i18n'
require 'bike_number'

class Bike < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  include HasOneSoftDelete
  extend FriendlyId

  friendly_id :label

  acts_as_commentable

  # Program ID is denormalized, referencing the active assignment for this bike
  attr_accessible :color, :value, :wheel_size, :seat_tube_height, :top_tube_length,
  :number, :quality, :condition, :program_id
  
  has_one :hook, :dependent => :nullify, :inverse_of => :bike
  has_one :departure
  has_many :assignments
  belongs_to :program

  include BikeMfg::ActsAsManufacturable
  
  # Override with value objects
  include Value::Color
  include Value::Linear::SeatTubeHeight
  include Value::Linear::TopTubeLength
  def wheel_size
    IsoBsdI18n::Size.new(super)
  end
  def number
    BikeNumber.new(super)
  end

  def self.qualities
    I18n.translate('bike.quality').keys.map{ |k| k.to_s }
  end
  def self.conditions
    I18n.translate('bike.condition').keys.map{ |k| k.to_s }
  end

  # Validations
  validates_presence_of :number,:color
  validates :seat_tube_height,:top_tube_length,:value, :numericality => true, :allow_nil => true
  validates_uniqueness_of :number, :allow_nil => true
  validates :number, :bike_number => :true
  validates :quality, 
  :inclusion => {:in => Bike.qualities}, :allow_nil => true
  validates :condition, 
  :inclusion => {:in => Bike.conditions}, :allow_nil => true

  def label
    "sn-#{self.number}"
  end
  
  def self.id_from_label(label, delimiter='-')
    arr = label.split(delimiter) if label
    id = arr[-1] if arr.count > 1
    return id
  end

  def self.find_by_label(label, delimiter='-')
    id = Bike.id_from_label(label, delimiter)
    Bike.find_by_number(id)
  end

  def departed?
    !!departure.nil?
  end
  

  def self.simple_search(search)
    Bike.where("number LIKE ?","%#{search}%").all
  end

  def entered_shop
    return self.created_at
  end

  def assign_program(program_id)
    current_assignment = self.assignments.where("active = ?",true).first
    if(current_assignment)
        current_assignment.active = false
        current_assignment.closed_at = DateTime.now()
        current_assignment.save
    end
    new_assignment = Assignment.new
    new_assignment.bike_id = self.id
    new_assignment.program_id = program_id
    new_assignment.active = true
    new_assignment.save
    self.program_id = program_id
    self.save
  end

end
