class Project::ScrapDetail < ProjectDetail

  attr_accessible :description

  # No requirements for scrap, so always passing
  def pass_req?
    true
  end

end
