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

class Project::Youth < Project
  has_one :detail, :as => :proj, :class_name => "Project::YouthDetail"

  # FIXME Find a better way to associate the response set with the project
  # and project detail model so that url_for is simple and also so
  # that the association is defined & updated in the detail
  #
  # Maybe override model_name in the detail class and then also
  # extend friendly_id in the detail class so that a path to the detail
  # will always become a path to the project
  #
  # Another approach is the open this class inside the detail class definition
  # and add the association there
  has_one :inspection, :class_name=>'ResponseSet', :as => :biz_process
end
