class MobileController < ApplicationController
  layout false
  def index
    @search = params[:search] || ""
    @programs = []
    Program.all.each do |p|
        @programs.push(p.id)
    end
    @programs.push("-1")
    @programs.push("-2")
    allBikes = Bike.filter_bikes(Bike::COLORS,@programs,"number",@search,0,10,"false")
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
    @colors = Bike::COLORS
    @brands = Brand.mobile_brands
  end

  def find_submit
    @bike_number = params[:number]
    @hook_number = params[:hook]
    @brand = params[:brand]
    @color = params[:color]
    bike = Bike.find_by_number(@bike_number)
    if bike
        redirect_to :controller => "mobile", :action => "show", :id => @bike_number
        return
    end
    hook = Bike.find_by_label(@hook_number)
    if hook and hook.bike
        redirect_to :controller => "mobile", :action => "show", :id => hook.bike.number
        return
    end
    redirect_to :controller => "mobile", :action => "index", :search => "#{@brand} #{@color}"
    return
  end

  def add
  end

  def show
    @bike_number = params[:id]
    @bike = Bike.find_by_number(@bike_number)
  end

end
