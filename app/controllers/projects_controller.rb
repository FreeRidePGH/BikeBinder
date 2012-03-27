class ProjectsController < ApplicationController
  before_filter :find_program
  before_filter :scope_projects

  def index
  end

  def show
    get_bike_and_project_instances
  end

  def new
    # Determine the program for this project
    @program = Program.find(params[:program_id])
    @project = (@program.nil?) ? Project.new :  @program.projects.build
  end

  def create
    @bike = Bike.find(params[:bike_id])
    @category = @program.project_category unless @program.nil?

    proj_class = @category.project_class unless @category.nil?
    proj_class ||= params[:project_type].constantize
    
    if proj_class
      @project = proj_class.new(params[:project]) do |new_proj|
        new_proj.assign_to(params)
      end

      if @project.save
        flash = {:success => "New project was started."}
        redirect_to project_path(@project) and return
      end
    end

    render 'new'
  end

  def update
  end

  def destroy
    get_bike_and_project_instances
    if @project and @project.cancel
      flash[:success] = "Project was canceled for bike #{@bike.number}."
      redirect_to bike_path(@bike) and return
    end
    
    flash[:failure] = "Project could not be found or canceled."
    render 'show'
  end

  private 

  # When the friendly_id references the bike.number
  # there is no DB column for that, so the find must
  # be done on the Bike model.
  def get_bike_and_project_instances
    @bike = Bike.find(params[:id])
    @project = @bike.project unless @bike.nil?
    @comment = Comment.build_from(@project, current_user, "")
  end

  # Determine if the controller is called from a nested route
  # See http://stackoverflow.com/questions/4120537/tell-if-a-controller-is-being-used-in-a-nested-route-in-rails-3#4120631
  def find_program
    @program = Program.find(params[:program_id]) if params[:program_id]
  end
  
  def scope_projects
    @projects = @program ? @program.projects : Project
  end

end
