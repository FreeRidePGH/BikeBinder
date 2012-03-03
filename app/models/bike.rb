# == Schema Information
#
# Table name: bikes
#
#  id               :integer         not null, primary key
#  color            :string(255)
#  value            :float
#  seat_tube_height :float
#  top_tube_length  :float
#  created_at       :datetime
#  updated_at       :datetime
#  mfg              :string(255)
#  model            :string(255)
#  number           :integer
#  hook_id          :integer
#  hook_number      :integer
#

class Bike < ActiveRecord::Base
  attr_accessible :color, :value, :seat_tube_height, :top_tube_length, :mfg, :model, :number

  has_one :hook, :inverse_of=>:bike

end
