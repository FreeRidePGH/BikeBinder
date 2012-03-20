class Project::Eab < Project
  has_one :spec, :as => :specable, :class_name => "Project::Spec::Eab"
end
