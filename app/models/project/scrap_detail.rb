class Project::ScrapDetail < ProjectDetail

  attr_accessible :description

  # No requirements for scrap, so always passing
  def pass_req?
    true
  end

end
# == Schema Information
#
# Table name: project_scrap_details
#
#  id          :integer         not null, primary key
#  proj_id     :integer
#  proj_type   :string(255)
#  state       :string(255)
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

