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

  before_filter :verify_bike, :except => [:new, :create, :index]

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
    @title = "Bikes#Index"
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

  # Project from mass assignment
  # See https://gist.github.com/1975644
  # http://rubysource.com/rails-mass-assignment-issue-a-php-perspective/
  def bike_params
    params[:bike].slice(:color, :value, :seat_tube_height, :top_tube_length, :mfg, :model, :number) if params[:bike]
  end

end
