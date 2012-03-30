class ProjectsController < ApplicationController

  expose(:bike){Bike.find_by_number(params[:id])}

  expose(:project) do
    @proj ||= (bike.project if bike)
    @proj ||= (category.project_class.new(params[:project]) if category)
  end

  expose(:comment) do
    @comment ||= (Comment.build_from(project, current_user, "") if project)
  end

  def index
  end

  def show
  end

  def new
  end

  def create
    if project
      project.assign_to(params)

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
