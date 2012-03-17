# == Schema Information
#
# Table name: programs
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Program < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  
  has_many :projects, :as => :projectable

  validates_presence_of :category, :title
  validates_uniqueness_of :title, :allow_nil=>false

  attr_accessible :title, :category
  
end

