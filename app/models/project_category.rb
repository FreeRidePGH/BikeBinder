# This class represents the rules associated with
# a category of projects.
#
# Example rules may include:
# * How many programs may use projects of this category

class ProjectCategory < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged]

  validates_presence_of :name, :project_type, :max_programs
  

  has_many :programs
  has_many :projects

  attr_accessible :name, :project_type, :max_programs

  def project_class
    project_type.constantize
  end

  def accepting_programs?
    (max_programs<0) || (programs.count < max_programs)
  end

  def self.accepting_programs
    collection = []
    ProjectCategory.all.each do |cat|
      if cat.accepting_programs?
        collection << cat
      end
    end
    collection
  end

end

# == Schema Information
#
# Table name: project_categories
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  project_type :string(255)
#  max_programs :integer
#  slug         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

