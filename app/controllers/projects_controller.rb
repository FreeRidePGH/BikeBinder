class ProjectsController < ApplicationController
  before_filter :find_program
  before_filter :scope_projects

  def index
  end

  def show
    get_bike_and_project_instances
    @comment = Comment.build_from(@project, current_user, "")
  end

  def new
    # Determine the program for this project
    @program = Program.find(params[:program_id])
    @project = (@program.nil?) ? \
    Project.new :  @program.projects.build
  end

  def create
    @program = Program.find(params[:program_id])
    @bike = Bike.find(params[:bike_id])
    if @bike and @program
      category = @program.project_category
      proj_scope = category.project_class
      
      @project = proj_scope.new()
      
      @program.projects << @project
      @program.save!

      @project.bike = @bike
      @bike.save!

      @project.project_category = category
      @project.save!

      flash = {:success => "New project was started."}
      redirect_to project_path(@project)
    else
      render 'new'
    end
  end

  def update
  end

  def destroy
    get_bike_and_project_instances
    if @project and not @bike.departed?
      @project.destroy
      @bike.project_id = nil
      @bike.save!
      flash[:success] = "Project was canceled for bike #{@bike.number}."
    else
      flash[:failure] = "Project could not be found or canceled."
    end
    redirect_to projects_path
  end

  private 

  # When the friendly_id references the bike.number
  # there is no DB column for that, so the find must
  # be done on the Bike model.
  def get_bike_and_project_instances
    @bike = Bike.find(params[:id])
    @project = @bike.project unless @bike.nil?
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
