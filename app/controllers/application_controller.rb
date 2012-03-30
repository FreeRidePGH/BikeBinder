class ApplicationController < ActionController::Base
  protect_from_forgery
  
  expose(:categories) {ProjectCategory.all} 
  expose(:category) do
    cat_id = :project_category_id
    @cat ||= (ProjectCategory.find(params[cat_id]) if params[cat_id])
    @cat ||= (program.project_category if program)
  end

  expose(:programs) {Program.all}
  expose(:program) do
    @prog ||= (Program.find(params[:program_id]) if params[:program_id])
  end

  expose(:bikes)
  expose(:bike){Bike.find_by_number(params[:bike_id])}


  # Determine if the controller is called from a nested route
  # http://stackoverflow.com/questions/4120537/tell-if-a-controller-is-being-used-in-a-nested-route-in-rails-3#4120631
  expose(:projects) do
    @project_scope ||= (program.projects if program)
    @project_scope ||= (category.projects if category)
    @project_scope ||= Project.all
  end

  # When the friendly_id references the bike.number
  # there is no DB column for that, so the find must
  # be done on the Bike model.
  # Once the bike is found, its project is found.
  expose(:project) do
    @proj ||= (bike.project if bike)
    @proj ||= (program.projects.build if program)
    @proj ||= Project.new
  end


  def new_comment
    @commentable = params[:controller].singularize.classify.constantize.find(params[:id])
    
    @comment = Comment.build_from(@commentable, current_user, 
                                  params[:comment][:body])
    if @comment.save
      # Handle a successful save
      flash[:success] = "Thank you for your comment"
    else
      # Failed save
      flash[:error] = "Could not add your comment"
    end
    redirect_to @commentable
  end

  # Checks if a bike record was found
  def bike_found?
    not (bike.nil? or  bike.id.nil?)
  end 

  def project_found?
    not (project.nil? or project.id.nil?)
  end

end
