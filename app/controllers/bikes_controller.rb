class BikesController < ApplicationController
  
  # Fetch by:
  # * id or bike_id
  # Create by:
  # Bike.new
  expose(:bike) do
    id_param = params[:id]||params[:bike_id]
    unless id_param.blank?
      label = id_param
      @bike ||= Bike.find_by_label(label) unless label.nil?
    end    
    @bike ||= Bike.new(bike_params)
  end
  # Fetch by:
  # Array of single bike when bike is found & fetched
  # All bikes
  expose(:bikes) do
    @bikes ||= ([bike] if bike_found?)
    @bikes ||= Bike.all 
  end

  # Fetch by
  # * bike's hook if bike is fetched
  # * hook_id if specified
  # * next available from the Hook model
  expose(:hook) do
    @hook ||= (bike.hook if bike)
    @hook ||= (Hook.find_by_id(params[:hook_id]) if params[:hook_id])
    @hook ||= Hook.next_available
  end

  # Exposed to speciy object to build new comments on
  expose(:commentable) do
    @commentable ||= bike
  end

  before_filter :verify_bike, :except => [:new, :create, :index,:get_models,:get_brands,:filter_bikes,:get_details]
  before_filter :verify_brandmodels, :only => [:create,:update]
  before_filter :convert_units, :only => [:create,:update]
  
  def new
    @title = "Add a new bike"
    @form_text = "Create new bike"
  end

  def create     
    if bike.save
      flash[:success] = "New bike was added."
      redirect_to bike_path(bike) and return
    end
    render :new
  end

  def show
    @title = "Bike #{bike.number} Overview"
    @program = Program.new
  end

  def index
    @title = "Bike Listing"
    @brands = Brand.all_brands
    @colors = Bike.all_colors
    @statuses = Program.all_programs
    @sorts = Bike.sort_filters
    @searchTerm = params[:search]
  end

  def edit
    @title = "Edit details for bike " + @bike.number
  end

  def update
    if bike.update_attributes(params[:bike])
      flash.now[:success] = "Bike information updated."
      redirect_to bike
    else
      @title = "Edit Bike"
      render 'edit'
    end
  end
  
  def get_models
    @brand_id = params[:brand_id]
    @bike_models = []
    if @brand_id.nil? || @brand_id == ""
        @bike_models = []
    else
        @bike_models = BikeModel.find_all_by_brand_id(@brand_id)
    end
    render :json => @bike_models
  end

  def get_brands
    @model_id = params[:bike_model_id]
    @brands = []
    if @model_id.nil? || @model_id == ""
        @brands = []
    else
        @brands = Brand.find_all_for_models(@model_id)
    end
    render :json => @brands
  end

  def filter_bikes
    #@brand = params[:brands]
    @color = params[:colors]
    @status = params[:statuses]
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

  def get_details
    @bike = Bike.get_bike_details(params[:id])
    render :json => @bike
  end


  # Case the project is done, but not closed:
  #   Confirmation to close the project (FINISH project)
  #   Note: a project is done but not closed if it meets all
  #   project requirements, but it has just not been closed yet
  #
  # Case the project is not done, render page with options:
  #   Go to project to finish it (SHOW project) 
  #   - or -
  #   Close anyway (FINISH project)
  #
  # Case there is no project:
  #   Options & form to start a new project (render page with depart form)
  #
  # Case the bike is already departed:
  #   Notify error (SHOW bike)
  #
  # via GET
  def depart
    if bike.nil?
      redirect_to root and return
    end

    if bike.departed?
      flash[:error] = "Bike has already departed"
      redirect_to bike and return
    end

    bike.departed_at = DateTime.now
    bike.save!
    flash[:success] = "Bike departed"
    redirect_to bike and return
 end

  def vacate_hook
    if bike.vacate_hook
      flash[:success] = "Hook vacated"
    else
      flash[:error] = "Could not vacate hook"
    end

    redirect_to bike
  end

  def reserve_hook
    if params[:hook_id]
      hook = params[:hook_id]
    end
    if bike.reserve_hook_by_id(hook)
      flash[:success] = "Hook #{bike.hook.number} reserved successfully"
    else
      flash[:error] = "Could not reserve the hook."
    end
    
    redirect_to bike
  end

  def assign_program
    bike.assign_program(params[:program_id])
    redirect_to bike
  end

  def change_hook
    
  end
  

  private

  # Helper method that redirects if a bike record is not found
  def verify_bike
    if not bike_found?
      redirect_to bikes_path and return
    end
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

  def verify_brandmodels
    newBrand = params[:bike][:new_brand_id]
    newModel = params[:bike][:new_bike_model_id]
    oldBrand = params[:bike][:brand_id]
    # Case 1 new brand and model
    # Create new brands and models and assign this bike
    if (newBrand.nil? == false and newBrand != "" and newModel.nil? == false and newModel != "" and newBrand != "-1" and newModel != "-1")
        thisBrand = Brand.new(:name => newBrand)
        thisModel = BikeModel.new(:name => newModel,:brand_id => thisBrand.id)
        thisBrand.save!
        thisModel.save!
        bike.brand_id = thisBrand.id
        bike.bike_model_id = thisModel.id
        params[:bike][:brand_id] = thisBrand.id
        params[:bike][:bike_model_id] = thisModel.id
    # Case 2 new model and existing brand
    elsif (newModel.nil? == false and newModel != "" and oldBrand.nil? == false and oldBrand != "" and newBrand != "-1" and newModel != "-1")
        thisBrand = Brand.find_by_id(oldBrand)
        thisModel = BikeModel.new(:name => newModel, :brand_id => thisBrand.id)
        thisModel.save!
        bike.brand_id = thisBrand.id
        bike.bike_model_id = thisModel.id
        params[:bike][:brand_id] = thisBrand.id
        params[:bike][:bike_model_id] = thisModel.id
    # Case 3 new brand and no model
    elsif (newBrand.nil? == false and newBrand != "" and (newModel.nil? or newModel == "" or newModel == "-1"))
        thisBrand = Brand.new(:name => newBrand)
        thisBrand.save!
        bike.brand_id = thisBrand.id
        bike.bike_model_id = nil
        params[:bike][:brand_id] = thisBrand.id
        params[:bike][:bike_model_id] = nil
    # Case 4 new model and no brand
    elsif (newModel.nil? == false and newModel != "" and newModel != "-1" and (newBrand.nil? == true or newBrand == "" or newBrand == "-1"))
        thisModel = BikeModel.new(:name => newModel, :brand_id => nil)
        thisModel.save!
        bike.brand_id = nil
        bike.bike_model_id = thisModel.id
        params[:bike][:brand_id] = nil
        params[:bike][:bike_model_id] = thisModel.id
    end
    params[:bike].delete :new_brand_id
    params[:bike].delete :new_bike_model_id
  end

  # Project from mass assignment
  # See https://gist.github.com/1975644
  # http://rubysource.com/rails-mass-assignment-issue-a-php-perspective/
  def bike_params
    params[:bike].slice(:color, :value, :seat_tube_height, :top_tube_length, :bike_model_id, :brand_id, :model, :number, :quality, :condition, :wheel_size) if params[:bike]
  end

end
