
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

  def depart
    self.departed_at = Time.now
    self.vacate_hook!
    self.save
  end

  def departed?
    not self.departed_at.nil?
  end

  def vacate_hook!
    h = self.hook
    
    if h 
      h.bike = nil
      h.save
      return self.reload
    end
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
  
end
