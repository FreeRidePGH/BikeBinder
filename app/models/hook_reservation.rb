class HookReservation < ActiveRecord::Base

  attr_accessible :bike_id, :hook_id, :bike_state, :hook_state

  belongs_to :bike
  belongs_to :hook

  validates_presence_of :bike_id, :hook_id

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

end # class HookReservation
