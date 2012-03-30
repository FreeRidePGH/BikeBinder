class ProjectCategoriesController < ApplicationController
  
  expose(:category) do 
    cat_id = :project_category_id
    @cat ||= ProjectCategory.find(params[:id]||params[cat_id])
  end

  def show
    if category.nil? then redirect_to root_path and return end
  end

end
