class BikesController < ApplicationController
  
  # Fetch by:
  # * id or bike_id
  # Create by:
  # Bike.new
  expose(:bike) do
    @bike ||= Bike.find_by_number(params[:id]||params[:bike_id])
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
    @hook ||= (Hook.find(params[:hook_id]) if params[:hook_id])
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
    @title = "Information for bike #{bike.number}"
  end

  def index
    @title = "Bikes#Index"
  end

  def edit
    @title = "Edit information for bike " + @bike.number
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

  def depart
  end

  def send_away
    force = params[:force]

    allow_to_depart = (force == "all")
    allow_to_depart ||= (project and project.closed?)

    if allow_to_depart and bike.depart
      flash[:success] = "Bike has departed"     
      redirect_to bike and return
    end
    
    flash[:error] = bike.errors.messages[0] if bike.errors
    flash[:error] = "Project is open" if (project and project.open?)
    flash[:error] = "No project designated" if project.nil?

    # render gives the chance to:
    #   close the project
    #   create a project
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
