# == Schema Information
#
# Table name: programs
#
#  id                  :integer         not null, primary key
#  type                :string(255)
#  label               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class Program < ActiveRecord::Base

  attr_accessible :name, :label
  has_many :bikes
  

  def self.all_programs
    progs = Program.all
    @filters = Hash.new
    progs.each do |prog|
      @filters[prog.label] = prog.id
    end
    return @filters
  end  

  def active_bikes
    return self.bikes.where("departed_at IS NULL").count
  end

  def departed_bikes
    return self.bikes.where("departed_at NOT NULL").count
  end

end
