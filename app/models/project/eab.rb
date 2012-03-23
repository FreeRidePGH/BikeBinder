class Project::Eab < Project
  has_one :spec, :as => :specable, :class_name => "Project::Spec::Eab"
end
# == Schema Information
#
# Table name: projects
#
#  id                  :integer         not null, primary key
#  type                :string(255)
#  bike_id             :integer
#  projectable_id      :integer
#  projectable_type    :string(255)
#  label               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  project_category_id :integer
#

