class Assignment < ActiveRecord::Base
  
  attr_accessible :application, :bike
  attr_accessible :state
  
  has_one :bike, :as => :allotment
  
  # application specifies program
  belongs_to :application, :polymorphic => true

  validates_presence_of :bike, :application
  validate :bike_is_not_allotted

  # Constructor
  # @params Hash with
  #  :bike and :program
  # 
  def self.build(params)
    if (bike = params[:bike])
      bike.allotment = 
        self.new(:bike => bike,
                 :application => params[:program])
    else
      self.new(:application => params[:program])
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
