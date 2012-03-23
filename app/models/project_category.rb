# This class represents the rules associated with
# a category of projects.
#
# Example rules may include:
# * How many programs may use projects of this category

class ProjectCategory < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged]

  has_many :projects
  has_many :programs
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

