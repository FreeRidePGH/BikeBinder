# == Schema Information
#
# Table name: programs
#
#  id                  :integer         not null, primary key
#  title               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  cosed_at            :datetime
#  slug                :string(255)
#

class Program < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  
  has_many :projects, :as => :projectable
  belongs_to :project_category

  
  validates_presence_of :title
  validates_uniqueness_of :title, :allow_nil=>false
  validate :category_must_be_accepting_new_programs

  attr_accessible :title, :max_total, :max_open

  def category_must_be_accepting_new_programs 
    if project_category and not project_category.accepting_programs?
      errors.add(:project_category_id, "must be accepting new programs.")
    end
  end

end

