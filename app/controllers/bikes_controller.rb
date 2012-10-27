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

  before_filter :verify_bike, :except => [:new, :create, :index,:get_models,:filter_bikes]
  before_filter :verify_brandmodels, :only => [:create,:update]

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
  end

  def index
    @title = "Bike Listing"
    @brands = Brand.all_brands
    @colors = Bike.all_colors
    @statuses = Bike.all_statuses
    @sorts = Bike.sort_filters
    
    #filter_bikes()
    #@bikes = Bike.filter_bikes(@brands,@colors,@statuses,[@sorts.first], true)
    #render :json => @bikes
  end

  def edit
    @title = "Edit details for bike " + @bike.number
  end

  def update
    if bike.update_attributes(params[:bike])
      flash[:success] = "Bike information updated."
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

  def filter_bikes
    @brand = params[:brands]
    @color = params[:colors]
    @status = params[:statuses]
    @sortBy = params[:sortBy]
    @bikes = Bike.filter_bikes(@brand,@color,@status,@sortBy, true)
    render :json => @bikes
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

    project = bike.project

    if project.nil?
      is_done_project = false
    else
      is_done_project = project.terminal?
      is_done_project ||= project.detail.done?
    end

    if is_done_project
      redirect_to finish_project_path(project) and return
    end

    @title = "Depart Bike"
    render 'depart'
  end

  def vacate_hook
    if bike.vacate_hook!
      flash[:success] = "Hook vacated"
    else
      flash[:error] = "Could not vacate hook"
    end

    redirect_to bike
  end

  def reserve_hook
    if bike.reserve_hook!(hook)
      flash[:success] = "Hook #{bike.hook.number} reserved successfully"
    else
      flash[:error] = "Could not reserve the hook."
    end
    
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
