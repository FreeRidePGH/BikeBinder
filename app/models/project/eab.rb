class Project::Eab < Project
  has_one :detail, :as => :proj, :class_name => "Project::EabDetail"
end
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

