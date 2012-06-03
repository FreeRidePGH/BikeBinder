class ProjectsController < ApplicationController

  # Fetch by:
  # * Already fetched project_category
  # * program project category if program is fetched
  # ** Assumes 1:1 mapping from program to project category
  expose(:category) do
    @cat ||= project_category
    @cat ||= (program.project_category if program)
  end

  # Fetch by: 
  # id or bike_id
  expose(:bike) do
    id ||= params[:id] unless params[:id].blank?
    id ||= params[:bike_id] unless params[:bike_id].blank?
    @b ||= (Bike.find_by_number(id) if id)
  end

  # Fetch by:
  # * bike's project when bike is fetched
  # Create by:
  # category association when category is fetched
  expose(:project) do
    @proj ||= (bike.project if bike)
    @proj ||= (category.project_class.new(project_params) if category)
  end

  # Exposed to speciy object to build new comments on
  expose(:commentable) do
    @commentable ||= project
  end

  def index
    @title = "Projects#index"
  end

  def show
    if project.closed? 
      @title = "Project details (Closed)"
    else 
      @title =  "Project details"
    end
  end

  def new
    @title = "Create new project"
  end

  def create
    if project and project.assign_to(params)
      if project.save
        flash[:success] = "Bike was assigned to #{project.prog.title}"
        
        if project.terminal?
          redirect_to project.bike and return
        else
          redirect_to project_path(project) and return
        end
      end
    end

    render 'new'
  end

  def update
    # TODO updating and saving project details
    # Save the project details and the project
    render 'show'
  end

  def transition
    prefix = project.type.downcase.gsub("::", "_")
    proj_key = prefix.to_sym
    details_key = "#{prefix}_detail".to_sym

    # Call the detail event
    if params[details_key]
      detail_event = params[details_key][:state_events]
      if detail_event
        project.detail.fire_state_event(detail_event)
      end
    end

    # Call the project event with parameters
    if params[proj_key]
      proj_event = params[proj_key][:state_events]
      if proj_event
        opts = params[proj_key][:event_args]
        project.send(proj_event, opts)
      end
    end

    # TODO success message when transition occurs
    
    # TODO helper function that parses errors and adds to the flash
    # check for errors
    project.errors.messages.each do |key, val|
      flash[:error][("message_#{key.to_s}").to_sym]= "#{key.upcase.to_s} #{val}"
    end
    project.detail.errors.messages.each do |key, val|
      flash[:error][("message_#{key.to_s}").to_sym]= "#{key.upcase.to_s} #{val}"
    end
    
    if project.process_hash
      redirect_to project.process_hash and return
    else
      redirect_to project and return
    end
  end

  def destroy
    # TODO project cancel process
    if project and project.cancel
      flash[:success] = "Project was canceled for bike #{bike.number}."
      redirect_to bike_path(bike) and return
    end
    
    flash[:error] = "Project could not be found or canceled."
    render 'show'
  end

  private

  def project_params
    params[:project].slice() if params[:project]
  end

end
