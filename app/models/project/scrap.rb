class Project::Scrap < Project

  # Project always goes to
  # the closed state (effectively stateless)
  # 
  def self.terminal?; true end
end
