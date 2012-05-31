class Project::EabDetail < ProjectDetail

  state_machine :initial => :under_repair do
    
    event :repairs_complete do
      transition :under_repair => :ready_for_inspection
    end

    event :inspect do
      transition :ready_for_inspection => :ready_to_go, :if => :inspection_passed?
      transition :ready_for_inspection => :under_repair
    end
    
    state :under_repair
    state :ready_for_inspection
    state :ready_to_go
  end

  state_machine :status_state,  :initial => :active, :namespace => :status do

    after_transition any => :active, :do => :renew_action

    event :update do
      transition :active => :inactive , :if => "expired?"
      transition :inactive => :active
    end

    event :renew do
      transition any => :active
    end

    state :inactive
    state :active

  end


  private

  def renew_action
    # last_activity_at date.now
  end

  def expired?

  end

end
# == Schema Information
#
# Table name: project_eab_details
#
#  id           :integer         not null, primary key
#  proj_id      :integer
#  proj_type    :string(255)
#  state        :string(255)
#  status_state :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

