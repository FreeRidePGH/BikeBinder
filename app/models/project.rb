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

  has_one :bike, :dependent => :nullify, :inverse_of => :project
  belongs_to :prog, :polymorphic => true
  belongs_to :project_category

  # Does a child class override this?
  has_one :detail, :as => :proj

  acts_as_commentable

  state_machine  :initial => :open  do
    after_transition (any - :open) => :open, :do => :open_action
    after_transition (any - :closed) => :closed, :do => :close_action
    
    event :close do
      transition :open => :closed
    end

    event :cancel do
      transition :open => :trash
    end

    event :reopen do
      transition :closed => :open
    end

    event :restore do
      transition :trash => :open
    end
    
    state :open
    state :closed
    state :trash
  end

  state_machine :completion_state, :initial => :none , :namespace => :completion do
    event :update do
      transition  [:partial,:none] =>:done, :if => "detail.pass_req?"
      transition  [:none, :done] => :partial
    end

    event :reset do
      transition [:partial, :done] => :none
    end

    state :none
    state :partial
    state :done
  end

  attr_accessible nil

  def close_and_depart
    self.close
    self.bike.depart if bike
  end

  def self.open
    self.where{closed_at == nil}
  end

  def self.closed
    self.where{closed_at != nil}
  end

  def assign_to(opts={})
    program = Program.find(opts[:program_id]) unless opts[:program_id].blank?
    bike = Bike.find(opts[:bike_id]) unless opts[:bike_id].blank?
    category = program.project_category if program

    if not (program and bike and category and bike.available?) then return false end
    
    program.projects << self
    self.bike = bike
    category.projects << self

    self.create_detail(opts[:project_detail])
  end

  def label
    (bike.nil?) ? type+id.to_s  : bike.number
  end

  def category_name
    prog.project_category.name
  end

  validates_presence_of :type

  private

  def close_action
    self.closed_at = Time.now
    self.save
  end

  def open_action
    self.closed_at = nil
    self.save
  end
  
end
