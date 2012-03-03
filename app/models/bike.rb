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
#  mfg              :string(255)
#  model            :string(255)
#  number           :integer
#  hook_id          :integer
#  hook_number      :integer
#

class Bike < ActiveRecord::Base
  acts_as_commentable

  attr_accessible :color, :value, :seat_tube_height, :top_tube_length, :mfg, :model, :number

  validates_uniqueness_of :hook_id, :number, :allow_nil => true

  has_one :hook, :inverse_of=>:bike

  def vacate_hook!
    h = self.hook
    
    if h 
      h.bike = nil
      h.save

      self.hook = nil
      self.save

      return true
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
    self.save

    return true
  end

  def number_label
    return sprintf("%05d", self.number) if self.number
  end
  
  def notes
    self.comment_threads
  end

end
