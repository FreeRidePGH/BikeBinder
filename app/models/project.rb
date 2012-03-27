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
    self.close_at = nil
    self.save
  end

  def open?
    self.closed_at.nil?
  end

  def assign_to(opts={})
    program = Program.find(opts[:program_id])
    bike = Bike.find(opts[:bike_id])

    if not (program and bike) then return false end
    
    program.projects << self
    program.save

    self.bike = bike
    bike.save

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
