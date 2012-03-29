class ProjectCategoriesController < ApplicationController
  def show
    @category = ProjectCategory.find(params[:id])
    if @category.nil? then redirect_to root_path and return end
    @projects = @category.projects
  end

end
