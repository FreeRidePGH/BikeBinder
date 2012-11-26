class MobileController < ApplicationController
  layout false
  def index
    @programs = []
    Program.all.each do |p|
        @programs.push(p.id)
    end
    @programs.push("-1")
    @programs.push("-2")
    allBikes = Bike.filter_bikes(Bike::COLORS,@programs,"number","",0,10,"false")
    @bikes = allBikes["bikes"]
  end

  def filter_bikes
    @color = Bike::COLORS
    @status = []
    Program.all.each do |p|
        @status.push(p.id)
    end
    @status.push("-1")
    @status.push("-2")
    @sortBy = params[:sortBy] 
    @search = params[:searchDesc] 
    @min = params[:min] 
    @max = params[:max] 
    @all = params[:all] 
    @bikes = Bike.filter_bikes(@color,@status,@sortBy,@search,@min,@max,@all) 
    @bikes["bikes"].each do |bike| 
        bikeDate = bike.created_at 
        bike.created_at = bikeDate.utc.to_i * 1000 
    end
    render :json => @bikes
  end

  def home
  end

  def find
  end

  def add
  end

  def show
  end

end
