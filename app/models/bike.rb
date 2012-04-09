
# == Schema Information
#
# Table name: bikes
#
#  id               :integer         not null, primary key
#  color            :string(255)
#  value            :float
#  seat_tube_height :float
#  top_tube_length  :float
#  created_at       :datetime
#  updated_at       :datetime
#  departed_at      :datetime
#  mfg              :string(255)
#  model            :string(255)
#  number           :string(255)
#  project_id       :integer
#

class Bike < ActiveRecord::Base
  extend FriendlyId
  friendly_id :number

  acts_as_commentable

  attr_accessible :color, :value, :seat_tube_height, :top_tube_length, :mfg, :model, :number
  
  has_one :hook, :dependent => :nullify, :inverse_of=>:bike
  belongs_to :project, :inverse_of => :bike

  state_machine :location_state, :initial => :shop do
    after_transition (any - :departed) => :departed , :do => :depart_action
    after_transition :departed => (any-:departed), :do => :return_action
    before_transition :hook => (any - :hook), :do => :vacate_hook_action

    event :depart do
      transition [:shop, :hook] => :departed
    end

    event :return do
      transition [:departed,:offsite] => :hook, :if => :hook
      transition [:departed,:offsite] => :shop 
    end

    event :get_hook do
      transition :shop => :hook, :if => :hook
    end

    event :vacate_hook do
      transition :hook => :shop, :unless => :hook
    end

    event :travel_offsite do
      transition :shop => :offsite
      transition :hook => :offsite
    end

    state :departed 
    state :shop 
    state :hook
    state :offsite
  end

  def self.unavailable
    self.where{(departed_at != nil) | (project_id != nil) }
  end

  def self.available
    self.where{(departed_at == nil) & (project_id == nil)}
  end

  def available?
    departed_at.nil? and project.nil?
  end
  
  def unavailable?
    not available?
  end
  
  def self.departed
    self.where{departed_at != nil}
  end


  def reserve_hook!(target_hook=nil)
    if self.hook
      return false
    end

    target_hook = Hook.next_available unless target_hook
    
    # Make sure there is a target hook
    # There may not be ay available
    unless target_hook
      return false
    end

    self.hook = target_hook
    self.save!

    return true
  end

  def self.format_number(num)
    return sprintf("%05d", num.to_i) if num
  end
    
  def self.number_pattern
    return /\d{5}/
  end

  validates_uniqueness_of :number, :allow_nil => true
  validates :number, :format => { :with => Bike.number_pattern, :message => "Must be 5 digits only"}
  
  def self.format_number(num)
    return sprintf("%05d", num.to_i) if num
  end
    
  def self.number_pattern
    return /\d{5}/
  end

  validates_uniqueness_of :number, :allow_nil => true
  validates :number, :format => { :with => Bike.number_pattern, :message => "Must be 5 digits only"}
  
  # Enforce the 1:1 association with the project
  validates_uniqueness_of :project_id, :allow_nil => true
  
  private
  
  def depart_action
    self.departed_at = Time.now
    self.save
  end  

  def return_action
    self.departed_at = nil
    self.save
  end

  def vacate_hook_action
    h = self.hook
    
    if h 
      h.bike = nil
      h.save
      return self.reload
    end
  end
end
