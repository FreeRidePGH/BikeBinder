class Program < ActiveRecord::Base

  # Attributes
  # :name, :label

  has_many :assignments, :as => :application
  has_many :bikes, :through => :assignments

  hound

  validates_presence_of :name, :label
  validates_uniqueness_of :name, :label

end
