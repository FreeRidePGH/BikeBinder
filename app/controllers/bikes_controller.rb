class BikesController < ApplicationController
  
  # Fetch by:
  # * id or bike_id
  # Create by:
  # Bike.new()
  expose(:bike) do
    id_param = params[:id]||params[:bike_id]
    if id_param.present?
      slug = id_param
      @bike ||= Bike.find_by_slug(slug) unless slug.blank?
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
    @brands = nil
    @colors = ColorNameI18n::keys
    @searchTerm = params[:search]
  end

  def show
    @title = "Bike #{bike.number} Overview"
    @program = Program.new
    (redirect_to bikes_path and return) if fetch_failed?(bike)
  end

  def new
    @title = "Add a new bike"
  end

  def create     
    if bike_form.save
      flash[:success] = "New bike was added."

      path = (params[:commit].downcase == I18n.translate('commit_btn.new_plus').downcase) ?
      new_bike_path : bike_path(bike_form.bike)

      redirect_to path and return
    end
    render :new
  end

  def edit
    @title = "Edit details for bike " + bike.number.to_s
    (redirect_to bikes_path and return) if fetch_failed?(bike)
  end

  def update
    (redirect_to bikes_path and return) if fetch_failed?(bike)

    if bike_form.save
      @title = "Bike #{bike.number} Overview"
      flash.now[:success] = "Bike information updated."
      redirect_to bike and return
    end

    @title = "Edit Bike"
    render 'edit'
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

  def assign_program
    bike.assign_program(params[:program_id])
    redirect_to bike
  end

  private

  # Protect from mass assignment
  # See https://gist.github.com/1975644
  # http://rubysource.com/rails-mass-assignment-issue-a-php-perspective/
  def bike_form_params
    params[:bike_form].slice(*BikeForm.form_params_list) if params[:bike_form]
  end

end
