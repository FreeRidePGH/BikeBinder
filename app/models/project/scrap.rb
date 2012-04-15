class Project::Scrap < Project

  has_one :detail, :as => :proj, :class_name => "Project::ScrapDetail"

  # Project always goes to
  # the closed state (effectively stateless)
  # 
  def self.terminal?; true end

end
