# == Schema Information
#
# Table name: programs
#
#  id               :integer         not null, primary key
#  title            :string(255)
#  program_category :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Program < ActiveRecord::Base
  
  has_many :projects, :as => :projectable
  
end

