
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

  # Program ID is denormalized, referencing the active assignment for this bike
  attr_accessible :color, :value, :wheel_size, :seat_tube_height, :top_tube_length, :bike_model_id, :brand_id, :number, :quality, :condition, :program_id
  
  has_one :hook, :dependent => :nullify, :inverse_of => :bike
  has_many :assignments
  belongs_to :program
  belongs_to :brand
  belongs_to :bike_model

  # Validations
  validates_presence_of :number,:color
  validates :seat_tube_height,:top_tube_length,:value, :numericality => true, :allow_nil => true

  # Callbacks for setting scrap programs as departed
  before_create :depart_scrap
  before_update :depart_scrap
  after_create  :check_hook
  after_update  :check_hook

  WHEEL_SIZES =     [["Unknown",1],
                     ["622 mm",622],
                     ["630 mm",630],
                     ["597 mm",597],
                     ["590 mm",590],
                     ["587 mm",587],
                     ["571 mm",571],
                     ["559 mm",559],
                     ["507 mm",507],
                     ["406 mm",406],
                     ["305 mm",305],
                     ["Other",2]]

  COLORS = ["White","Silver","Gray","Black","Red","Brown","Tan","Maroon",
            "Yellow","Gold","Orange","Olive","DarkGreen","Green","LightGreen",
            "Teal","Blue","LightBlue","Navy","Pink","Purple"]

  STATUSES = ["Available","EAB","Youth","Departed"]

  def depart_scrap
    if self.program_id == Program.where("name = ?","Scrap").first.id
        current_assignment = self.assignments.where("active = ?",true).first
        if current_assignment
            current_assignment.closed_at = DateTime.now()
        end
        self.departed_at = DateTime.now()
    end
  end
 
  def check_hook
    if self.departed_at.nil? == false
      if self.hook
        h = Hook.find_by_id(self.hook)
        h.update_attribute(:bike_id,nil)
      end
    end
  end

  def vacate_hook
    if self.nil? == false and self.hook.nil? == false
      h = self.hook
      h.bike = nil
      h.save!
    end
  end

  def reserve_hook_by_id(hook_id)
    if self.nil? == false and self.hook.nil? == true
      h = Hook.find_by_id(hook_id)
      h.bike = self
      h.save!
    end
  end

  def self.filter_bikes(colors,status,sortBy,search,min,max,all)
    statusSql = []
    if status.nil? or status.empty?
        return []
    end
    if status.include?("-1")
        statusSql.push("departed_at IS NULL AND program_id IS NULL")
        status.delete("-1")
    end
    if status.include?("-2")
        statusSql.push("departed_at IS NOT NULL")
        status.delete("-2")
    end
    if status.empty? == false
        statusSql.push("departed_at IS NULL AND program_id IN (#{status.join(",")})")
    end
    statusSqlString = "(" +  statusSql.join(") OR (") + ")"
    searchSql = []
    search.split.each do |ss|
        searchSql.push("bikes.number LIKE '%#{ss}%' OR bikes.color LIKE '%#{ss}%' OR brands.name LIKE '%#{ss}%'")
    end
    puts searchSql
    if search.nil? or search.empty?
        searchSqlString = "1=1"
    else
        searchSqlString = "(" + searchSql.join(") AND (") + ")"
    end
    count = Bike.select("bikes.*,programs.*,hooks.*,COALESCE(brands.name,'') as brand_name")
            .joins("LEFT JOIN hooks ON hooks.bike_id = bikes.id 
                    LEFT JOIN programs ON programs.id = bikes.program_id
                    LEFT JOIN brands ON brands.id = bikes.brand_id")
            .where("color IN (?) AND (#{statusSqlString}) AND (#{searchSqlString})",colors)
    bikes = Bike.select("bikes.*,programs.name,hooks.number as hook_number,COALESCE(brands.name,'n/a') as brand_name")
            .joins("LEFT JOIN hooks ON hooks.bike_id = bikes.id 
                    LEFT JOIN programs ON programs.id = bikes.program_id
                    LEFT JOIN brands ON brands.id = bikes.brand_id")
            .where("color IN (?) AND (#{statusSqlString}) AND (#{searchSqlString})",colors)
            .order(sortBy)
            .limit((all == "true" ? 2000 : 10))
            .offset(min)
    bikeJSON = {"count" => count.length, "bikes" => bikes}
    return bikeJSON
  end

  def self.get_bike_details(bike_number)
    bike = Bike.select("bikes.*,programs.name,bike_models.name as model_name,hooks.number as hook_number,brands.name as brand_name")
            .joins("LEFT JOIN hooks ON hooks.bike_id = bikes.id 
                    LEFT JOIN programs ON programs.id = bikes.program_id
                    LEFT JOIN brands ON brands.id = bikes.brand_id
                    LEFT JOIN bike_models ON brands.id = bike_models.brand_id")
            .where("bikes.number = ?",bike_number).first
    return bike
  end

  # Clean up all associations
  # See http://www.mrchucho.net/2008/09/30/the-correct-way-to-override-activerecordbasedestroy
  def destroy_without_callbacks
    unless new_record?
      # (May need to iterate through bike.versions)
    end
    super
  end

  def reserve_hook
    h = Hook.next_available
    if h
        h.update_attribute(:bike_id,self.id)
    end
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
    self.where{(departed_at != nil) | (program_id != nil) }
  end

  def self.available
    self.where{(departed_at == nil) & (program_id == nil)}
  end

  def available?
    departed_at.nil? and program.nil?
  end
  
  def unavailable?
    not available?
  end

  def departed?
    departed_at.nil? == false
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
    return WHEEL_SIZES 
  end

  def get_wheel_size
    wheelHash = WHEEL_SIZES
    wheelHash.each do |key|
        if key[1] == self.wheel_size
            return key[0]
        end
    end
    if self.wheel_size.nil? == false
        return self.wheel_size.to_s + " mm"
    else
        return "n/a"
    end
  end

  def self.qualities
    {"A" => "A","B" => "B","C" => "C","D" => "D"}
  end

  def self.conditions
    {"A" => "A","B" => "B","C" => "C","D" => "D"}
  end

  def entered_shop
    return self.created_at.strftime("%m/%d/%Y")
  end

  def self.all_colors
    return COLORS  
  end

  def self.all_statuses
    return STATUSES
  end

  def self.sort_filters
    return {"Number" => "number","Seat Tube" => "seat_tube_height","Top Tube" => "top_tube_length",
            "Wheel Size" => "wheel_size", "Date Entered" => "created_at"}
  end

  validates_uniqueness_of :number, :allow_nil => true
  validates :number, :format => { :with => Bike.number_pattern, :message => "Must be 5 digits exactly"}
  
 
  def assign_program(program_id)
    current_assignment = self.assignments.where("active = ?",true).first
    if(current_assignment)
        current_assignment.active = false
        current_assignment.closed_at = DateTime.now()
        current_assignment.save
    end
    new_assignment = Assignment.new
    new_assignment.bike_id = self.id
    new_assignment.program_id = program_id
    new_assignment.active = true
    new_assignment.save
    self.program_id = program_id
    self.save
  end
 
  private

  def depart_action
    self.departed_at = Time.now
    self.vacate_hook_action
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
