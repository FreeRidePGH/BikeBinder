
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
#  date_in_shop     :datetime
#  bike_model_id    :integer
#  brand_id         :integer
#  number           :string(255)
#  location_state   :string(255)
#

require "has_one_soft_delete"


class Bike < ActiveRecord::Base
  include HasOneSoftDelete
  extend FriendlyId

  friendly_id :label

  acts_as_commentable

  attr_accessible :color, :value, :wheel_size, :seat_tube_height, :top_tube_length, :bike_model_id, :brand_id, :number, :quality, :condition
  
  has_one :hook, :dependent => :nullify, :inverse_of=>:bike
  belongs_to :brand
  belongs_to :bike_model
  has_many :inspections, :class_name=>'ResponseSet', :as => :surveyable

  has_one_and_soft_delete :project, :dependent => :destroy #, :inverse_of => :bike

  # Clean up all associations
  # See http://www.mrchucho.net/2008/09/30/the-correct-way-to-override-activerecordbasedestroy
  def destroy_without_callbacks
    unless new_record?
      # make sure old projects are destroyed
      project.destroy
      # (May need to iterate through bike.versions)
    end
    super
  end

  state_machine :location_state, :initial => :shop do
    after_transition (any - :departed) => :departed , :do => :depart_action
    after_transition :departed => (any-:departed), :do => :return_action
    before_transition :hook => any, :do => :vacate_hook_action
    before_transition any => :hook, :do => :get_hook_action

    event :depart do
      transition [:shop, :hook] => :departed, :unless => 'project.nil?'
    end

    event :return do
      transition [:departed,:offsite] => :hook, :if => :hook
      transition [:departed,:offsite] => :shop 
    end

    event :reserve_hook do
      transition :shop => :hook, :unless => :hook
    end

    event :vacate_hook do
      transition :hook => :shop, :if => :hook
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

  def label
    "sn-#{self.number}"
  end
  
  def self.id_from_label(label, delimiter='-')
    arr = label.split(delimiter) if label
    id = arr[-1] if arr.count > 1
    return id
  end

  def self.find_by_label(label, delimiter='-')
    id = Bike.id_from_label(label, delimiter)
    Bike.find_by_number(id)
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
  
  def self.format_number(num)
    return sprintf("%05d", num.to_i) if num
  end
    
  def self.number_pattern
    return /\d{5}/
  end

  def self.simple_search(search)
    Bike.where("number LIKE ?","%#{search}%").all
  end

  def brand_name
    if !self.brand_id
       return "None"
    else
       return self.brand.name
    end
  end

  def model_name
    if self.bike_model.nil?
        return "None"
    else
        return self.bike_model.name
    end
  end

  def self.wheel_sizes
    [["Unknown",1],
     ["660 mm",660],
     ["680 mm",680],
     ["Other",2]]
  end

  def self.qualities
    {"A" => "A","B" => "B","C" => "C","D" => "D"}
  end

  def self.conditions
    {"A" => "A","B" => "B","C" => "C","D" => "D"}
  end

  validates_uniqueness_of :number, :allow_nil => true
  validates :number, :format => { :with => Bike.number_pattern, :message => "Must be 5 digits only"}
  
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

  def get_hook_action(transition)
    h = transition.args[0] if transition.args
    hook = h if h.is_a? Hook
    hook ||= Hook.next_available
    self.hook = hook
  end

end
