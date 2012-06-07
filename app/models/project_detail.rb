class ProjectDetail < ActiveRecord::Base

  # For table name prefixing see:
  # http://stackoverflow.com/questions/8911046/rails-table-name-prefix-missing
  self.abstract_class = true
  self.table_name_prefix = "project_"

  belongs_to :proj, :polymorphic => :true

  has_paper_trail :class_name => 'ProjectDetailVersion',
                  :meta => {:state => Proc.new{|detail| detail.state}}

  after_save "proj.update_completion", :if => :proj

  attr_accessible nil

  def pass_req?
    nil
  end

  def initial_state
    if @init_state
      return @init_state
    end

    states = self.class.state_machine.states
    states.each do |s|
      if s.initial?
        @init_state = s.name
        return @init_state
      end
    end
  end

  def completion_steps
    if @steps.nil? && !self.proj.terminal?
      # states = state_paths(:from => initial_state).to_states
      # states.insert(0, initial_state)
      states = self.class.state_machine.states.by_priority
      
      @steps = []

      states.each do |s|
        @steps.push s.name
      end
    end
    return @steps
  end

  # For every step, fetch the version that
  # the previous and next steps were
  # transitioned from and to, respectively.
  def transitions()
    steps = completion_steps

    retval = {}
    vref = self.versions.last

    steps.each do |sname|
      retval[sname.to_sym] = vref.transition_context(sname)
    end

    retval
  end

  # validate if a user can perform a given action
  def user_can?(user, action)
    true
  end

  # method definition to allow superclass call
  # as needed by state machine
  def process_hash
    nil
  end

  # Make sure that only one detail record is made for a given project
  validates_uniqueness_of :proj_id, :allow_nil => :false

  private
  
  def proj_must_be_open(transition)
    proj_detail = transition.object

    if proj_detail.proj.open?
      true
    else
      proj_detail.errors.add(:action_unallowed, "Project is closed")
      throw :halt
      false
    end
  end

end
