class Departure < ActiveRecord::Base
  attr_accessible :bike, :method, :value
  attr_reader :date
end
