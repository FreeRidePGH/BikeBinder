class Destination < ActiveRecord::Base

  attr_accessible :name, :label

  validates_presence_of :name, :label
  validates_uniqueness_of :name, :label

  has_many :allotments, :as => :application
  has_many :bikes, :through => :allotments

end
