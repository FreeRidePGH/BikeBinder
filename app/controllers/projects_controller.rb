class ProjectsController < ApplicationController
  before_filter :find_program
  before_filter :scope_projects

  def index
  end

  def show
    @project = @projects.find(params[:id])
    @comment = Comment.build_from(@project, current_user, "")
  end

  private 

  # Determine if the controller is called from a nested route
  # See http://stackoverflow.com/questions/4120537/tell-if-a-controller-is-being-used-in-a-nested-route-in-rails-3#4120631
  def find_program
    @program = Program.find(params[:program_id]) if params[:program_id]
  end
  
  def scope_projects
    @projects = @program ? @program.projects : Project
  end

end
