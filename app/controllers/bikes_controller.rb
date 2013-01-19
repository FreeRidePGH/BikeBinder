class BikesController < ApplicationController
  
  # Fetch by:
  # * id or bike_id
  # Create by:
  # Bike.new()
  expose(:bike) do
    id_param = params[:id]||params[:bike_id]
    if id_param.present?
      label = id_param
      @bike ||= Bike.find_by_label(label) unless label.nil?
      @bike ||= Bike.find_by_number(id_param)
    end    
    @bike ||= Bike.new
    @bike
  end
  # Fetch by:
  # Array of single bike when bike is found & fetched
  # All bikes
  expose(:bikes) do
    @bikes ||= ([bike] if record_found?(bike))
    @bikes ||= Bike.all 
    @bikes
  end

  # The bike_form is action sensative, so it is defined
  # in each action. This expose give the view access to
  # the correct bike_form object
  expose(:bike_form) do
    @bike_form ||= BikeForm.new(bike, bike_form_params)
    @bike_form
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


  def index
    @title = "Bike Listing"
    @brands = nil
    @colors = ColorNameI18n::keys
    @statuses = Program.all_programs
    @sorts = Bike.sort_filters
    @searchTerm = params[:search]
  end

  def show
    @title = "Bike #{bike.number} Overview"
    @program = Program.new
    verify_bike
  end

  def new
    @title = "Add a new bike"
  end

  def create     
    if bike_form.save
      flash[:success] = "New bike was added."
      redirect_to bike_path(bike_form.bike) and return
    end
    render :new
  end

  def edit
    @title = "Edit details for bike " + bike.number.to_s
    verify_bike
  end

  def update
    verify_bike
    if bike_form.save
      @title = "Bike #{bike.number} Overview"
      flash.now[:success] = "Bike information updated."
      #redirect_to bike and return
    end

    @title = "Edit Bike"
    render 'edit'
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
        @brands = BikeBrand.find_all_for_models(@model_id)
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
    bike = Bike.get_bike_details(params[:id])
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
    if not record_found?(bike)
      redirect_to bikes_path and return
    end
  end

  # Method to convert cm to inches
  def convert_units
  end

  # Method to create and or assign bike model
  def verify_brandmodels

    # Case 1 new brand and model
    # Create new brands and models and assign this bike

    # Case 2 new model and existing brand

    # Case 3 new brand and no model

    # Case 4 new model and no brand

  end

  # Project from mass assignment
  # See https://gist.github.com/1975644
  # http://rubysource.com/rails-mass-assignment-issue-a-php-perspective/
  def bike_form_params
    params[:bike_form].slice(*BikeForm.form_params_list) if params[:bike_form]
  end

end
