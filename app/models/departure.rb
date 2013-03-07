class Departure < ActiveRecord::Base
  has_one :method, :as => :assignable
  belongs_to :bike

  attr_accessible :bike, :value

  validates_presence_of :bike_id,:value,:method_id,:method_type

  def departed_at
    self.created_at
  end
end
