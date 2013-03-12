class Assignment < ActiveRecord::Base
  
  attr_accessible :application, :bike
  attr_accessible :state
  
  # application specifies program, etc
  belongs_to :application, :polymorphic => true
  belongs_to :bike

  validates_presence_of :bike, :application
  validates_uniqueness_of :bike_id

  # Constructor
  # @params Hash with
  #  :bike and :program
  # 
  def self.build(params)
    if (bike = params[:bike])
      self.new(:bike => bike,
               :application => params[:program] || params[:application])
    else
      self.new(:application => params[:program] || params[:application])
    end
  end # self.build

  private
  
  def bike_is_not_allotted
    return if bike.nil?
    conflicting_allotment = !bike.allotment_id.nil? && bike.allotment_id != id
    if conflicting_allotment
      errors.add(:bike, "Already is allotted")
    end
  end
  
end
