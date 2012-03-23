# == Schema Information
#
# Table name: programs
#
#  id                  :integer         not null, primary key
#  title               :string(255)
#  project_category_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#  slug                :string(255)
#  max_open            :integer
#  max_total           :integer
#

class Program < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  
  has_many :projects, :as => :projectable
  belongs_to :project_category

  validates_presence_of :project_category_id, :title
  validates_uniqueness_of :title, :allow_nil=>false

  attr_accessible :title, :max_total, :max_open
  
end

