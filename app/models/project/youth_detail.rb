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

  # TODO Modularize inspection logic in an acts_as_inspectable gem
  INSPECTION_TITLE = "Bike Overhaul Inspection"
  def self.inspection_args
    h = {}
    h[:title] = INSPECTION_TITLE
    h[:context_scope] = :proj
    h[:start_point] = :under_repair
    h[:end_point] = :ready_for_program
    h[:reinspectable] = [:ready_for_program, :class_material]
    return h
  end
  include Inspection

  include ProjectDetailMixin

  def pass_req?
    self.class_material?
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

