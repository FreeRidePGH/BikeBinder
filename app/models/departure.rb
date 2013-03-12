# require 'active_support/core_ext/module/aliasing'

class Departure < ActiveRecord::Base

  ############
  # Attributes

  attr_accessible :value, :application, :bike
  alias_attribute :departed_at, :created_at

  ##############
  # Associations

  has_one :assignment, :as => :application
  has_one :bike, :through => :assignment

  # application specifies a 
  # program or destination
  belongs_to :application, :polymorphic => true
  alias_attribute :method, :application

  #############
  # Validations

  validates_presence_of :value, :application
  validates_associated :assignment
  
  # Constructor
  # 
  # Assigns a new departure to the bike.
  #
  # When a bike already has an assignment,
  # the application of the assignment becomes
  # the departure method.
  #
  # When the bike is already departed, then
  # the current departure is returned instead
  # of a new one being built.
  # 
  # @params Hash with
  #  :bike and optional :destination
  # 
  def self.build(params)
    if (bike = params[:bike])
      # vacate the hook if applicable
      bike.hook_reservation.delete if bike.hook_reservation
      
      if bike.departed?
        bike.application
      else
        bridge_destination(
                           bike,
                           self.new(
                                    :value => params[:value], 
                                    :application =>build_destination(bike, params[:destination])
                                    )
                           )
      end # if bike.departed?
    else # bike
      self.new(params)
    end
  end

  private

  # Determine the destination to assign
  # when building a departure
  # 
  def self.build_destination(bike, destination)
    (bike.application || destination) unless bike.departed?
  end

  # The departure acts as an intermediate
  # node (like a linked list) when an application
  # already exists for the bike.
  #
  # When theh application does not exist, then
  # the given destination is used
  def self.build_assignment(bike, departure)
    return nil if bike.nil?

    if bike.assignment
      bike.assignment
    else
      Assignment.build(:bike => bike, :application => departure)
    end
  end
  
  # Make sure the current assignment (if any) for the bike
  # becomes associated to the departure
  def self.bridge_destination(bike, departure)
    departure.assignment = build_assignment(bike, departure)
    departure.assignment.application = departure
  end

end # class Departure
