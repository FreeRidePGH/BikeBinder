class MobileController < ApplicationController
  layout false
  def index
    @programs = []
    Program.all.each do |p|
        @programs.push(p.id)
    end
    @programs.push("-1")
    @programs.push("-2")
    @bikes = Bike.filter_bikes(Bike::COLORS,@programs,"number","")
  end

end
