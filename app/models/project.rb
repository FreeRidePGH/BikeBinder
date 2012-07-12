# == Schema Information
#
# Table name: projects
#
#  id                  :integer         not null, primary key
#  type                :string(255)
#  prog_id             :integer
#  prog_type           :string(255)
#  label               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  closed_at           :datetime
#  project_category_id :integer
#  state               :string(255)
#  completion_state    :string(255)
#

class Project < ActiveRecord::Base

  extend FriendlyId
  extend ActiveModel::Naming

  friendly_id :label

  has_one :bike, :inverse_of => :project
  belongs_to :prog, :polymorphic => true
  belongs_to :project_category

  # Override the model_name method so that url_for will work
  # See http://api.rubyonrails.org/classes/ActiveModel/Naming.html
  def self.model_name
    ActiveModel::Name.new(self, nil, self.base_class.to_s)
  end

  # See http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
  #  def attachable_type(sType)
  #    super(sType.to_s.classify.constantize.base_class.to_s)
  #  end

  acts_as_commentable

  state_machine  :initial => :open  do
    after_transition (any - :open) => :open, :do => :open_action
    after_transition (any - :closed) => :closed, :do => :close_action
    after_transition (any-:trash) => :trash, :do => :cancel_action
    
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

  attr_accessible nil

  def self.open
    self.where{state == 'open'}
  end

  def self.closed
    self.where{state == 'closed'}
  end

  def self.trash
    self.where{state == 'trash'}
  end

  def assign_to(opts={})
    program = Program.find(opts[:program_id]) unless opts[:program_id].blank?
    bike = Bike.find_by_id(opts[:bike_id]) unless opts[:bike_id].blank?
    category = program.project_category if program

    if not (program and bike and category and bike.available?) then return false end
    
    program.projects << self
    self.bike = bike
    category.projects << self

    self.create_detail(opts[:project_detail])
  end

  def label
    (bike.nil?) ? type+id.to_s  : "sn-#{bike.number}"
  end

  def self.find_by_label(label, delimiter='-')
    bike = Bike.find_by_label(label, delimiter)
    return bike.project if bike
  end

  # When the project is in the middle of a process
  # this hash provides paramaters to resume that process
  def process_hash
    h = detail.process_hash if detail.respond_to? :process_hash
  end

  def category_name
    prog.project_category.name
  end

  validates_presence_of :type, :bike, :project_category, :prog_id, :prog_type
  validates_associated :bike, :project_category

  # Indicate if the project always
  # goes to the closed state
  # 
  def self.terminal?
    false
  end

  def terminal?
    self.class.terminal?
  end

  # Specify if a project type is automatically
  # set to the closed state when first created
  # (Effectively, stateless projects, like
  # scrap or sales)
  after_initialize :close, :if => :terminal?


  private

  # The close action will depart the bike
  # unless explicitly specified via args
  # 
  # If a bike can not depart, then the close
  # action fails.
  def close_action(transition)
    h = transition.args[0] if transition.args
    proj = transition.object
    proj ||= self

    return false if proj.bike.nil? 

    remain = false #defaults to bike departing
    if h 
      remain ||= ActiveRecord::ConnectionAdapters::Column.value_to_boolean(h[:remain])
    end
    depart = !remain

    # Flag to specify if the close action should
    # be carried out
    should_close = true

    if depart
      proj.bike.depart
      
      # make sure the depart action worked
      should_close = proj.bike.departed?
    end
    
    if should_close
      proj.closed_at = Time.now
      proj.save
    end
  end

  def open_action
    self.closed_at = nil
    self.save
  end

  def cancel_action
    bike.project = nil
    bike.save
  end

  # Allows for each project type to associate to 
  # details specific to that type
  def self.has_detail
    has_one :detail, :as => :proj, :class_name => "#{self.to_s}Detail", :dependent => :destroy
  end

  def self.inherited(base)
    base.has_detail
    super
  end

end
