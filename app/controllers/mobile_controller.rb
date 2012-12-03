require('rqrcode')

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

  def generate_code
    respond_to do |format|
        qrurl = "http://intense-chamber-9854.herokuapp.com/mobile/show/"+params[:id]
        @qr = RQRCode::QRCode.new(qrurl, :size => 7)
        @number = params[:id]
        format.html
    end
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
    bike = params[:bike]
    if bike
        @errors = []
        convert_units()
        newBike = Bike.new(params[:bike])
        if newBike.save
            redirect_to :controller => "mobile", :action => "show", :id => newBike.number
            return
        else
            @errors.push("Invalid Data")
        end
    end
  end

  def show
    @bike_number = params[:id]
    @bike = Bike.find_by_number(@bike_number)
  end

  # Method to convert cm to inches 
  def convert_units 
    ttu = params[:bike][:top_tube_unit] 
    stu = params[:bike][:seat_tube_unit] 
    if stu == "centimeters" 
      sth = params[:bike][:seat_tube_height].to_i 
      sth = sth * 0.393701 
      puts sth 
      params[:bike][:seat_tube_height] = sth 
    end 
    if ttu == "centimeters" 
      ttl = params[:bike][:top_tube_length].to_i 
      ttl = ttl * 0.393701 
      params[:bike][:top_tube_length] = ttl 
    end 
    params[:bike].delete :seat_tube_unit 
    params[:bike].delete :top_tube_unit 
  end 


end
