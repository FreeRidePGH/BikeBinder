class HookReservation < ActiveRecord::Base

  #############
  # Attributes

  attr_accessible :bike, :hook, :bike_state, :hook_state

  ##############
  # Associations

  belongs_to :bike
  belongs_to :hook

  ############
  # Properties

  state_machine :bike_state, :initial => :present, :namespace => 'bike'  do
    event :lose do
      transition all => :missing
    end
    event :find do
      transition all => :present
    end

    state :missing
    state :present
  end

  state_machine :hook_state, :initial => :resolved, :namespace => 'hook' do
    event :raise_issue do
      transition all => :unresolved
    end

    event :resolve do
      transition all => :resolved
    end
    
    state :resolved
    state :unresolved
  end

  #############
  # Validations

  validates_presence_of :bike, :hook
  validate :bike_can_not_be_departed
  validates_uniqueness_of :bike_id, :hook_id

  private 

  def bike_can_not_be_departed
    if bike && bike.departed?
      errors.add(:bike, "Can not reserve a hook after it has departed")
    end
  end
end # class HookReservation
