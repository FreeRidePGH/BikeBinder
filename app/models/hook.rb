# == Schema Information
#
# Table name: hooks
#
#  id         :integer         not null, primary key
#  number     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Hook < ActiveRecord::Base
  validates_presence_of :number
  validates_uniqueness_of :number

 scope :with_number, lambda{|number| {:conditions =>['number= ? ', number]}}
  

end
