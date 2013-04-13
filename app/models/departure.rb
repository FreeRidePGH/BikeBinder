# require 'active_support/core_ext/module/aliasing'

class Departure < ActiveRecord::Base
  
  ############
  # Attributes

  attr_accessible :value, :application, :bike
  alias_attribute :departed_at, :created_at

  ##############
  # Associations

  has_one :assignment, :as => :application, :dependent => :nullify
  has_one :bike, :through => :assignment

  # application specifies a 
  # program or destination
  belongs_to :application, :polymorphic => true
  alias_attribute :method, :application

  ############
  # Properties
  def label
    application.label
  end

  def name
    application.name
  end

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
        bike.departure
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

  before_destroy :unchain_application

  private
  
  # A returned item gets its original
  # assignment restored.
  # 
  # When the departure method is a destination
  # then the item is assumed to not be assigned.
  def unchain_application
    if self.application_type == "Destination"
      !! self.assignment.destroy
    else
      self.assignment.application = self.application
      !! self.assignment.save!
    end
  end

  # Determine the destination to assign
  # when building a departure
  # 
  # @param bike that the destination is build for
  # @param (Destination, Integer) destination is a destination
  # or destination id that can be found
  def self.build_destination(bike, destination)
    return nil if bike.departed?
    dest = bike.application
    dest ||= destination if destination.respond_to?(:departures)
    dest ||= Destination.where(:id=>destination.to_i).first if destination.respond_to?(:to_i)
    return dest
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
