class Bike < ActiveRecord::Base
  attr_accessible :bike, :method, :value
  att_reader :date
end
