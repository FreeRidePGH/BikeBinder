class BikesController < ApplicationController
  
  before_filter :fetch_bike, 
  :except => [:new, :create, :index]

  expose(:bike) do
    @bike ||= Bike.find_by_number(params[:id]||params[:bike_id])
    @bike ||= Bike.new(params[:bike])
  end
  expose(:bikes) do
    @bikes ||= ([bike] if bike_found?)
    @bikes ||= Bike.all 
  end

  expose(:hook) do
    @hook ||= (bike.hook if bike)
    @hook ||= (Hook.find(params[:hook_id]) if params[:hook_id])
    @hook ||= Hook.next_available
  end

  expose(:comment){ @comm ||= Comment.build_from(bike, current_user, "")}

  def new
  end

  def create    
    render :new
  end

  def show
    @title = "Information for bike #{bike.number}"
  end

  def index
    @title = "Bikes Index"
  end

  def edit
    @title = "Edit Bike"
  end

  def update
    if bike.update_attributes(params[:bike])
      flash[:success] = "Bike info updated"
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
    
    flash[:fail] = bike.errors.messages[0] if bike.errors
    flash[:fail] = "Project is open" if (project and project.open?)
    flash[:fail] = "No project designated" if project.nil?

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
  def fetch_bike
    if not bike_found?
      redirect_to bikes_path and return
    end
  end

end
