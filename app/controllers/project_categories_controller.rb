class ProjectCategoriesController < ApplicationController

  expose(:category) do 
    cat_id = :project_category_id
    @cat ||= ProjectCategory.find(params[:id]||params[cat_id])
  end

  # Scope projects by
  # * Projects under a category when a category is fetched
  expose(:projects) do
    @proj_scope ||= (category.projects if category)
  end

  def show
    @title = category.name + " Project Category"
    if category.nil? then redirect_to root_path and return end
  end

end
