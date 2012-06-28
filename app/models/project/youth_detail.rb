class Project::YouthDetail < ProjectDetail

  state_machine :initial => :under_repair do

    event :select_for_class do
      transition :ready_for_program => :class_material
    end

    event :remove_from_class do
      transition :class_material => :ready_for_program
    end

    state :under_repair
    state :ready_for_program
    state :class_material
  end # state_machine

  has_inspection(
                 :title => "Bike Overhaul Inspection",
                 :inspectable => "proj.bike",
                 :context_scope => :proj, #ommit from options to let self be scope
                 :start_point => :under_repair,
                 :end_point => :ready_for_program,
                 :reinspectable => [:ready_for_program, :class_material]
                 )
  
  include ProjectDetailStates

  def pass_req?
    self.class_material?
  end

  has_time_sheet

end
# == Schema Information
#
# Table name: project_youth_details
#
#  id                     :integer         not null, primary key
#  proj_id                :integer
#  proj_type              :string(255)
#  state                  :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  inspection_access_code :string(255)
#

