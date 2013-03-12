require 'bike_mfg'
require 'color_name-i18n'
require 'bike_number'
require 'number_slug'

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
  :number, :quality, :condition
  
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

  ##############
  # Associations

  include BikeMfg::ActsAsManufacturable
  alias_attribute :model, :bike_model

  has_one :hook_reservation
  has_one :hook, :through => :hook_reservation

  belongs_to :allotment, :polymorphic => true

  ############
  # Properties

  def departed?
    allotment && allotment.respond_to?(:departed_at)
  end

  def available?
    allotment.blank?
  end

  def shop?
    !departed?
  end
  
  def entered_shop
    return self.created_at
  end

  #############
  # Validations

  validates_presence_of :number,:color
  validates :seat_tube_height,:top_tube_length,:value, :numericality => true, :allow_nil => true
  validates_uniqueness_of :number, :allow_nil => true, :message => "Number is not unique"
  validates :number, :bike_number => :true
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
