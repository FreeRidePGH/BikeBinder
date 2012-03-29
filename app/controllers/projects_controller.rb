class ProjectsController < ApplicationController
  before_filter :find_program
  before_filter :scope_projects

  def index
  end

  def show
    get_bike_and_project_instances
  end

  def new
    @bike = Bike.find(params[:bike_id]) if params[:bike_id]
    @category = @program.project_category if @program
    @category ||= ProjectCategory.find(params[:category_id]) if params[:category_id]

    @project = @program.projects.build if @program
    @project ||= @projects.new
  end

  def create
    @bike = Bike.find(params[:bike_id])
    @category = ProjectCategory.find(params[:category_id]) if params[:category_id]
    @category ||= @program.project_category if @program

    proj_class = @category.project_class if @category
    
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
    @bike = Bike.find(params[:id]) unless params[:id].nil?
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
