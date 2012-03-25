# == Schema Information
#
# Table name: projects
#
#  id                  :integer         not null, primary key
#  type                :string(255)
#  bike_id             :integer
#  projectable_id      :integer
#  projectable_type    :string(255)
#  label               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  project_category_id :integer
#

class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :label

  validates_presence_of :type

  has_one :bike, :inverse_of => :project
  belongs_to :projectable, :polymorphic => true
  belongs_to :project_category
  
  acts_as_commentable

  # Does a child class override this?
  #has_one :spec, :as => :specable

  attr_accessible nil

  def label
    (bike.nil?) ? type+id.to_s  : bike.number
  end

  def category_name
    project_category.name
  end
end
