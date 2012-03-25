# This class represents the rules associated with
# a category of projects.
#
# Example rules may include:
# * How many programs may use projects of this category

class ProjectCategory < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged]

  validates_presence_of :name, :project_type, :max_programs

  has_many :projects
  has_many :programs

  attr_accessible :name, :project_type, :max_programs

  def project_class
    project_type.constantize
  end
end

# == Schema Information
#
# Table name: project_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

