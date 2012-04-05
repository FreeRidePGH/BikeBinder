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
    @b ||= Bike.find_by_number(id) if id
  end

  # Fetch by:
  # * bike's project when bike is fetched
  # Create by:
  # category association when category is fetched
  expose(:project) do
    @proj ||= (bike.project if bike)
    @proj ||= (category.project_class.new(params[:project]) if category)
  end

  # Exposed to speciy object to build new comments on
  expose(:commentable) do
    @commentable ||= project
  end

  def index
  end

  def show
  end

  def new
  end

  def create
    if project and project.assign_to(params)
      if project.save
        flash = {:success => "New project was started."}
        redirect_to project_path(project) and return
      end
    end

    render 'new'
  end

  def update
  end

  def destroy
    if project and project.cancel
      flash[:success] = "Project was canceled for bike #{bike.number}."
      redirect_to bike_path(bike) and return
    end
    
    flash[:failure] = "Project could not be found or canceled."
    render 'show'
  end

end
