class Assignment < ActiveRecord::Base
  
  attr_accessible :application, :bike
  attr_accessible :state
  
  has_one :bike, :as => :allotment
  # application specifies program
  belongs_to :application, :polymorphic => true

  validates_presence_of :bike, :application

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
  
end
