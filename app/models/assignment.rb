class Assignment < ActiveRecord::Base
  
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

  before_destroy :destroy_chain

  private

  # When the application is another assignment
  # then that assignment needs to be destroyed.
  # 
  def destroy_chain
    if application.respond_to?(:application)
      application.destroy
    end
  end
  
  def bike_is_not_allotted
    return if bike.nil?
    conflicting_allotment = !bike.allotment_id.nil? && bike.allotment_id != id
    if conflicting_allotment
      errors.add(:bike, "Already is allotted")
    end
  end
  
end
