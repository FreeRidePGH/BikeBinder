class Project::EAB < Project
  has_one :spec, :as => :specable, :class_name => "Project::Spec::EAB"
end
