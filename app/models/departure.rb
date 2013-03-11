# require 'active_support/core_ext/module/aliasing'

class Departure < ActiveRecord::Base

  ############
  # Attributes

  attr_accessible :value, :bike, :application
  alias_attribute :departed_at, :created_at

  ##############
  # Associations

  has_one :bike, :as => :allotment
  # application specifies a program or destination
  belongs_to :application, :polymorphic => true
  alias_attribute :method, :application

  #############
  # Validations

  validates_presence_of :value, :bike, :application

  # Constructor
  # @params Hash with
  #  :bike and optional :destination
  # 
  def self.build(params)
    if (bike = apply_destination!(params[:bike], params[:destination]) )
      # vacate the hook if applicable
      bike.hook_reservation.delete if bike.hook_reservation
      bike.allotment = bike.allotment.respond_to?(:departed_at) ? bike.allotment :
        self.new(:bike =>bike, 
                 :value => params[:value], 
                 :application => bike.allotment)
    else
      self.new(:bike => params[:bike])
    end
  end

  private

  def self.apply_destination!(bike, destination)
    return nil if bike.nil?

    if bike.allotment && bike.allotment.respond_to?(:departed_at)
      return bike
    end

    if destination_conflict?(bike, destination)
      raise "Conflict specifying destination when allotment already assigned"
    end
    
    if destination
      bike.allotment = destination
    elsif bike.allotment.respond_to?(:application)
      bike.allotment = bike.allotment.application
    end

    bike
  end

  def self.destination_conflict?(bike, destination)
    allotment_conflict = 
      !bike.nil? &&
      !bike.allotment.nil? &&
      !destination.nil? &&
      !(bike.allotment == destination)
  end

end # class Departure
