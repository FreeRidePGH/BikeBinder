# == Schema Information
#
# Table name: projects
#
#  id               :integer         not null, primary key
#  type             :string(255)
#  projectable_id   :integer
#  projectable_type :string(255)
#  label            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  closed_at        :datetime
#

class Project::Youth < Project
  has_one :spec, :as => :specable, :class_name => "Project::Spec::Youth"
end
