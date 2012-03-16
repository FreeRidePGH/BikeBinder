# == Schema Information
#
# Table name: projects
#
#  id               :integer         not null, primary key
#  project_category :string(255)
#  projectable_id   :integer
#  projectable_type :string(255)
#  bike_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Project < ActiveRecord::Base

  validates_presence_of :project_category

  belongs_to :bike, :inverse_of => :project
  belongs_to :projectable, :polymorphic => true

  #has_and_belongs_to_many :users, :inverse_of => projects
  
  acts_as_commentable

  # Does a child class override this?
  #has_one :spec, :as => :specable

end
