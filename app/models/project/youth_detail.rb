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

  include ProjectDetailStates

  has_inspection(
                 :title => "Bike Overhaul Inspection",
                 :inspectable => "proj.bike",
                 :context_scope => :proj, #ommit from options to let self be scope
                 :start_point => :under_repair,
                 :end_point => :ready_for_program,
                 :reinspectable => [:ready_for_program, :class_material]
                 )



  def pass_req?
    self.class_material?
  end

#  has_time_sheet

  def work_log
    self.time_entries
  end

  def build_work_entry(opts={})
    t_start = opts[:time_start]
    t_end = opts[:time_end]
    obj = self
    user_id = opts[:user].id if opts[:user]
    desc = opts[:description]
    category = "Repair"

    TimeEntry.build_from(:obj=>obj,
                             :user_id=>user_id,
                             :description => desc,
                             :context => category,
                             :start => t_start,
                             :end => t_end)
  end

  def create_work_entry(opts={})
    entry = build_work_entry(opts)
    entry.save if entry
  end

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

