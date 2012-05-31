module SurveyorControllerCustomMethods
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    # base.send :layout, 'surveyor_custom'
  end

  # Actions
  def new
    super
    # @title = "You can take these surveys"
  end
  def create
    super
  end
  def show
    super
  end
  def edit
    super
  end
  def update
    super
  end
  
  # Paths
  def surveyor_index
    # most of the above actions redirect to this method
    #super # available_surveys_path
    root_path
  end

  def surveyor_finish
    # the update action redirects to this method if given params[:finish]

    # @response_set is set in before_filter - set_response_set_and_render_context
    if @response_set
      surveyable_path
    else
      root_path
    end
  end

  def surveyable_path
    if @response_set.biz_process
      idstr = @response_set.biz_process.friendly_id
      idstr ||= @response_set.biz_process_id
      h = {:action => :show,
           :id => idstr,
           :controller => @response_set.biz_process_type.downcase.pluralize}
      url_for(h)
    elsif @response_set.surveyable
      url_for(@response_set.surveyable)
    else
      root_path
    end
  end
end
class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
end
