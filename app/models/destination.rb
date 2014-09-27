class Destination < ActiveRecord::Base
  
  # Attributes
  # :name, :label

  validates_presence_of :name, :label
  validates_uniqueness_of :name, :label

  has_many :allotments, :as => :application
  has_many :bikes, :through => :allotments

  has_many :departures, :as => :application
  has_many :bikes, :through => :departures

  hound

end
