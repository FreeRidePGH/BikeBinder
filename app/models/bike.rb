require 'bike_mfg'
require 'color_name-i18n'
require 'bike_number'
require 'number_slug'
require 'value/validator'

class Bike < ActiveRecord::Base

  #############
  # Attributes

  include ActiveModel::ForbiddenAttributesProtection

  extend FriendlyId
  extend NumberSlug

  friendly_id :slug
  number_slug :prefix => 'sn', :delimiter => '-'

  acts_as_commentable

  attr_accessible :color, :value, :wheel_size, :seat_tube_height, :top_tube_length,
  :number_record, :quality, :condition
  
  # Override with value objects
  include Value::Color
  include Value::Linear::SeatTubeHeight
  include Value::Linear::TopTubeLength
  include Value::Validator
  def wheel_size
    IsoBsdI18n::Size.new(super)
  end
  def number
    BikeNumber.new(number_record)
  end
  def number=(val)
    self.send('number_record=', val)
  end

  def self.qualities
    I18n.translate('bike.quality').keys.map{ |k| k.to_s }
  end
  def self.conditions
    I18n.translate('bike.condition').keys.map{ |k| k.to_s }
  end

  ##############
  # Associations

  include BikeMfg::ActsAsManufacturable
  has_one :bike_brand, :through => :bike_model
  alias_attribute :model, :bike_model
  alias_attribute :brand, :bike_brand

  has_one :hook_reservation, :dependent => :destroy
  has_one :hook, :through => :hook_reservation
  
  has_one :assignment, :dependent => :destroy
  has_one :program, :through => :assignment, :source_type => 'Assignment', :source => :application
  has_one :departure, :through => :assignment, :source => :application , :source_type => 'Assignment'

  hound

  ############
  # Properties

  def application
    assignment.application if assignment
  end

  def departed?
    application && application.respond_to?(:departed_at)
  end

  def available?
    assignment.blank?
  end

  def shop?
    !departed?
  end
  
  def entered_shop
    return self.created_at
  end

  #############
  # Validations

  validates_presence_of :number_record, :color
  validates :value, 
  :numericality => {:greater_than_or_equal_to => 0, :only_integer => false}, :allow_nil => true
  validates :seat_tube_height, :non_negative_number => true
  validates :top_tube_length, :non_negative_number => true

  validates_uniqueness_of :number_record, :allow_nil => true, 
  :message => I18n.translate('errors.taken_number')
  validates :number_record, :bike_number => :true
  validates :color, 
  :inclusion => {:in => Settings::Color.option_set}, :allow_nil => false
  validates :quality, 
  :inclusion => {:in => Bike.qualities}, :allow_nil => true
  validates :condition, 
  :inclusion => {:in => Bike.conditions}, :allow_nil => true

  ##########
  # Actions

  def self.simple_search(search)
    Bike.where("number LIKE ?","%#{search}%").all
  end

end
