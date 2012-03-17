# == Schema Information
#
# Table name: projects
#
#  id               :integer         not null, primary key
#  category         :string(255)
#  projectable_id   :integer
#  projectable_type :string(255)
#  bike_id          :integer
#  label            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Project::Youth < Project

  has_one :spec, :as => :specable, :class_name => "Project::Spec::Youth"

end
