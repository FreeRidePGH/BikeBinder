class Project::Scrap < Project

  has_one :detail, :as => :proj, :class_name => "Project::ScrapDetail"

  # Specify if a project type is automatically
  # set to the closed state when first created
  # (Effectively, stateless projects, like
  # scrap or sales)
  after_initialize :close_and_depart
end
