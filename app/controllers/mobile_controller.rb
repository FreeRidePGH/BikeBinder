require('rqrcode')

class MobileController < ApplicationController
  layout false

  # Browse Bikes Page
  def index
    @search = params[:search] || ""
    @programs = []
    Program.all.each do |p|
        @programs.push(p.id)
    end
    @programs.push("-1")
    @programs.push("-2")
    @statuses = Program.all_programs
    @colors = Bike.all_colors
    allBikes = Bike.filter_bikes(Bike::COLORS,@programs,"number",@search,0,10,"false")
    @bikes = allBikes["bikes"]
  end

  # AJAX Action to get Browse Bikes List
  def filter_bikes
    # Get Params
    @color = params[:color]
    @status = params[:status]
    @sortBy = params[:sortBy] 
    @search = params[:searchDesc] 
    @min = params[:min] 
    @max = params[:max] 
    @all = params[:all] 

    # Initialize Filter Arrays
    @colorArr = []
    @statusArr = []

    # Get Color Array
    if @color == "all"
        @colorArr = Bike::COLORS
    else
        @colorArr.push(@color)
    end

    # Get Program Array
    if @status == "all"
        Program.all.each do |p|
            @statusArr.push(p.id)
        end
        @statusArr.push("-1")
        @statusArr.push("-2")
    else
        @statusArr.push(@status.to_s)
    end

    # Model Method Call
    @bikes = Bike.filter_bikes(@colorArr,@statusArr,@sortBy,@search,@min,@max,@all) 
    
    # Render Json back to client
    @bikes["bikes"].each do |bike| 
        bikeDate = bike.created_at 
        bike.created_at = bikeDate.utc.to_i * 1000 
    end
    render :json => @bikes
  end

  # Home Menu Page
  def home
  end

  # Find Bike Page
  def find
    @colors = Bike::COLORS
    @brands = Brand.mobile_brands
  end

  # Generate QR Code
  def generate_code
    respond_to do |format|
        qrurl = "http://intense-chamber-9854.herokuapp.com/mobile/show/"+params[:id]
        @qr = RQRCode::QRCode.new(qrurl, :size => 7)
        @number = params[:id]
        format.html
    end
  end

  # Submit Action for Find POST Form
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
    hook = Hook.find_by_label(@hook_number)
    if hook and hook.bike
        redirect_to :controller => "mobile", :action => "show", :id => hook.bike.number
        return
    end
    redirect_to :controller => "mobile", :action => "index", :search => "#{@brand} #{@color}"
    return
  end

  # Action to Create a Bike
  def add
    # Get Params
    bike = params[:bike]
    if bike
        @errors = []
        # Convert CM/Inches
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

  # Action to Upload a Photo for a bike
  def upload
    # Get params
    photo = params[:file]
    number = params[:number]
    bike = Bike.find_by_number(number)
    success = true
    if bike.nil?
        success = false
    elsif photo
            # Create the directory
            directory = "public/photos"
            begin  
                # If the directory doesn't exist, create it
                Dir::mkdir(directory)
            rescue
                # directory exists
            end
            # Find the path located in public/photos/bike-XXXXX.jpeg
            path = File.join(directory,"bike-#{number}.jpeg")
            # Binary write the uploaded file to the path
            File.open(path,'wb') { |f| f.write(photo.read) }
    end
    render :json => { "success" => success }
  end

  # Action to show information for a bike
  def show
    @bike_number = params[:id]
    @bike = Bike.find_by_number(@bike_number)
  end

  # Method to convert cm to inches 
  def convert_units 
    # Get Params
    ttu = params[:bike][:top_tube_unit] 
    stu = params[:bike][:seat_tube_unit]
    if ttu and stu # Check that both exist 
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
    # Delete the parameters from the params hash since they are not part of the bike model
    params[:bike].delete :seat_tube_unit 
    params[:bike].delete :top_tube_unit
    end
  end 

  def ajax_show
    bike_number = params[:id]
    bike = Bike.get_bike_details(bike_number)
    render :json => bike
  end

  def ajax_find
    bike_number = params[:bikeFind]
    hook_number = params[:hookFind]
    bike = Bike.find_by_number(bike_number)
    hook = Hook.find_by_number(hook_number)
    if bike
        render :json => {"bike" => bike.number}
    elsif hook and hook.bike
        render :json => {"bike" => hook.bike.number}
    else
        render :json => {"bike" => nil}
    end
  end

  # Action to Create a Bike
  def ajax_add
    # Get Params
    bike = params[:bike]
    existing_bike = Bike.find_by_number(params[:bike][:number])
    ttl = params[:bike][:top_tube_length]
    sth = params[:bike][:seat_tube_height]
    value = params[:bike][:value]
    @errors = []
    if existing_bike.nil? == false
        @errors.push("Bike number already exists")
    end
    if @errors.empty? == true and bike
        # Convert CM/Inches
        #convert_units()
        convert_brands()
        newBike = Bike.new(params[:bike])
            if newBike.save
                render :json => {"errors" => @errors}
            return
        else
            @errors.push("Invalid Data")
        end
    end
    render :json => {"errors" => @errors}
  end

  def convert_brands
    brand = params[:bike][:brand]
    model = params[:bike][:model]
    existing_brand = Brand.find_by_name(brand)
    if existing_brand.nil? == false
        params[:bike][:brand_id] = existing_brand.id
        existing_model = BikeModel.where(:brand_id => existing_brand.id, :name => model).first
        if existing_model.nil? == false
            params[:bike][:bike_model_id] = existing_model.id
        else
            new_model = BikeModel.new(:name => model, :brand_id => existing_brand.id)
            new_model.save
            params[:bike][:bike_model_id] = new_model.id
        end
    else
        new_brand = Brand.new(:name => brand)
        new_model = BikeModel.new(:name => model, :brand_id => new_brand.id)
        new_brand.save
        new_model.save
        params[:bike][:brand_id] = new_brand.id
        params[:bike][:bike_model_id] = new_model.id
    end
    params[:bike].delete :brand
    params[:bike].delete :model
  end


end
