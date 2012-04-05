# == Schema Information
#
# Table name: projects
#
#  id               :integer         not null, primary key
#  type             :string(255)
#  projectable_id   :integer
#  projectable_type :string(255)
#  label            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  closed_at        :datetime
#

class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :label

  validates_presence_of :type

  has_one :bike, :dependent => :nullify, :inverse_of => :project
  belongs_to :projectable, :polymorphic => true
  belongs_to :project_category
  
  acts_as_commentable

  # Does a child class override this?
  #has_one :spec, :as => :specable

  attr_accessible nil

  # Specify if a project type is automatically
  # set to the closed state when first created
  # (Effectively, stateless projects, like
  # scrap or sales)
  def self.open_on_create?; true end
  def self.closed_on_create?
    not self.open_on_create?
  end

  def self.open
    self.where{closed_at == nil}
  end

  def self.closed
    self.where{closed_at != nil}
  end

  def close
    self.closed_at = Time.now
    self.save
  end

  def closed?
    not open?
  end

  def open
    self.closed_at = nil
    self.save
  end

  def open?
    self.closed_at.nil?
  end

  def assign_to(opts={})
    program = Program.find(opts[:program_id]) unless opts[:program_id].blank?
    bike = Bike.find(opts[:bike_id]) unless opts[:bike_id].blank?
    category = program.project_category if program

    if not (program and bike and category) then return false end
    
    program.projects << self
    program.save

    self.bike = bike
    bike.save

    category.projects << self
    category.save
    
    self.save
  end

  def label
    (bike.nil?) ? type+id.to_s  : bike.number
  end

  def category_name
    projectable.project_category.name
  end

  def cancellable?
    not bike.departed? unless bike.nil?
  end

  def cancel
    if self.cancellable?
      self.bike = nil
      self.destroy
    end
  end
end
