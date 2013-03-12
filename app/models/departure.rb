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
        return bike.application
      else
        
        departure = 
          self.new(
                   :value => params[:value], 
                   :application => build_destination(bike, params[:destination])
                   )
        
        departure.assignment = bike.assignment ?
        bike.assignment : Assignment.build(:bike => bike, 
                                           :application => departure)
        
        return (departure.assignment.application = departure)
      end
    else
      return self.new(params)
    end
    return

    if (bike = apply_destination!(params[:bike], params[:destination]) )
      bike.assignment.application = 
        bike.application.respond_to?(:departed_at) ? bike.application :
        self.new(:bike =>bike, 
                 :value => params[:value], 
                 :application => bike.application)
    else
      self.new(:bike => params[:bike])
    end
  end

  private

  # Determine the destination to assign
  # when building a departure
  # 
  def self.build_destination(bike, destination)
    (bike.application || destination) unless bike.departed?
  end

  # Assign the given destination as the application
  # for the departure assigned to the bike
  # 
  def self.apply_destination!(bike, destination)
    return nil if bike.nil?

    if bike.application && bike.application.respond_to?(:departed_at)
      # bike already has a departure application
      return bike
    end

    if destination_conflict?(bike, destination)
      raise "Conflict specifying destination when assignment already assigned"
    end
    
    if destination && bike.assignment
      bike.assignment.application = destination
    elsif bike.application && !bike.application.respond_to?(:departed_at)
      # The bike already has an application, but it is not a departure
      # 
      # Move the application to the departure method
      
      bike.assignment = bike.allotment.application
    end

    bike
  end

  def self.destination_conflict?(bike, destination)
    allotment_conflict = 
      !bike.nil? &&
      !bike.application.nil? &&
      !destination.nil? &&
      !(bike.application == destination)
  end

end # class Departure
