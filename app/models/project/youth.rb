# == Schema Information
#
# Table name: projects
#
#  id               :integer         not null, primary key
#  project_category :string(255)
#  projectable_id   :integer
#  projectable_type :string(255)
#  bike_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Project::Youth < Project

  has_one :spec, :as => :specable, :class_name => "Project::Spec::Youth"

end
