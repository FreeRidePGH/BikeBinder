# Helper methods to expose objects to the
# projects controller and any controllers
# nested under projects.
#
module ProjectsExposure 

  def self.included(base)
    # Fetch by:
    # * Already fetched project_category
    # * program project category if program is fetched
    # ** Assumes 1:1 mapping from program to project category
    base.expose(:category) do
      @cat ||= project_category
      @cat ||= (program.project_category if program)
    end
    
    # Fetch by: 
    # id or bike_id
    base.expose(:bike) do
      label ||= params[:id] unless params[:id].blank?
      label ||= params[:bike_id] unless params[:bike_id].blank?
      @b ||= (Bike.find_by_label(label) if label)
    end

    # Fetch by:
    # * bike's project when bike is fetched
    # Create by:
    # category association when category is fetched
    base.expose(:project) do
      @proj ||= (bike.project if bike)
      @proj ||= Project.find_by_label(params[:project_id]) unless params[:project_id].blank?
      @proj ||= Project.find_by_label(params[:id]) unless params[:id].blank?
      @proj ||= (category.project_class.new(project_params) if category)
    end

    # Exposed to speciy object to build new comments on
    base.expose(:commentable) do
      @commentable ||= project
    end

  end #self.included
    
end
