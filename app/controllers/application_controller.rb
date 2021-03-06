class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    # Note: it is more elegant to redirect to the root rather than
    # the sign-in page, but this means that the root page
    # should be viewable for any user (even guest)
    if current_user.nil?
      redirect_to new_user_session_url
    else
      render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    end
  end

  before_filter :set_timezone

  # Scope from collection of all categories
  expose(:project_categories) {ProjectCategory.all}
  # Fetch category by:
  # * project_category_id
  # Create never
  expose(:project_category) do
    id = :project_category_id
    @prjcat ||= (ProjectCategory.find(params[id]) unless params[id].blank?)
  end

  # Scope from collection of all programs
  expose(:programs) {Program.all}
  # Fetch by:
  # * program ID
  expose(:program) do
    @prog ||= (Program.where(:id => params[:program_id]).first unless params[:program_id].blank?)
  end

  # Default behavior
  expose(:bikes)
  # Fetch bike by: 
  # * bike_id matching bike number
  # Create never
  expose(:bike) do
    unless params[:bike_id].blank?
      slug = params[:bike_id]
      @bike ||= Bike.find_by_slug(slug) unless slug.blank?
    end
    @bike
  end
  

  # Scope projects by
  # * All projects
  #
  # See Tell if the controller is called from a nested route
  # http://stackoverflow.com/questions/4120537/tell-if-a-controller-is-being-used-in-a-nested-route-in-rails-3#4120631
  expose(:projects) do
    @project_scope ||= Project.all
  end

  # Fetch project by:
  # * bike when a bike is fetched & has a project
  # Create by:
  # * generic project
  expose(:project) do
    @proj ||= Project.find(params[:project_id]) unless params[:project_id].blank?
    # When the friendly_id references the bike.number
    # there is no DB column for that, so the find must
    # be done on the Bike model.
    # Once the bike is found, its project is found.
    @proj ||= (bike.project if bike)
    @proj ||= Project.new
  end

  expose(:comment_body) do
    params[:comment].permit(:body)[:body] if params[:comment]
  end

  # Create by:
  # * Build from commentable if commentable is fetched
  # ** Assumes calling controller exposes commentable
  # we should only expose comments if a user is logged in. Otherwise current.user.id throws an exception because it is nil
  expose(:comment) do
    if current_user
      @c_ret ||= (Comment.build_from(commentable, current_user.id, comment_body) if commentable)
    end
  end

  def new_comment
    if commentable
      authorize! :edit, commentable
      if comment && comment.save
        # Handle a successful save
        flash[:success] = "Thank you for your comment"
      else
        # Failed save
        flash[:error] = {:description => "Could not add your comment."}
        comment.errors.each do |key,val|
          flash[:error][("message_#{key.to_s}").to_sym]= "#{key.upcase.to_s} #{val}"
        end
      end
      redirect_to(:id=>commentable, :action=>:show)
    else
      redirect_to root_path
    end
  end

  # Checks if a record was found
  def record_found?(model)
    !model.nil? && !model.id.nil?
  end
  
  # Checks the given record is fetched and redirects if not 
  #
  # @params record (ActiveModel, #id) object to check if it is found
  # @params optns[:fallback_path] if the record is not found
  #
  # If no fallback url is given, then
  # the default is root_path
  def fetch_failed?(record, optns={})
    conditional = optns[:on] || :any
    
    # Coerce records into enumerable
    arr_records = record.respond_to?(:each) ? record : [record]
    
    # initialize the found flag
    found = (conditional == :any)
    arr_records.each do |r|
      case conditional
        when :any
        # AND
        found &&= record_found?(r)
        when :all
        # OR
        found ||= record_found?(r)
      end
    end
    
    return !found
  end # def fetch_failed?(record, optns={})

  def hound_user
    @hound_user ||= Signature.find_or_create(params.permit(:sig)[:sig])
  end

  def verify_signatory
    if hound_user.nil?
      flash[:error] = I18n.translate('controller.application.no_signature')
      return false
    end
    true
  end

  private 

  def set_timezone
    Time.zone = ActiveSupport::TimeZone.new('Eastern Time (US & Canada)')
  end

  def clear_flash
    flash.clear
  end
end
