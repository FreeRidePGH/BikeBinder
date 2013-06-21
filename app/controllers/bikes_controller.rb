require "ostruct"

class BikesController < ApplicationController

  layout false, :only => :qr
  
  # Fetch by:
  # * id or bike_id
  # Create by:
  # Bike.new()
  expose(:bike) do
    id_param = params[:id]||params[:bike_id]
    if id_param.present?
      slug = id_param
      @bike ||= Bike.find_by_slug(slug) unless slug.blank?
    end    
    @bike ||= Bike.new
    @bike
  end
  # Fetch by:
  # Array of single bike when bike is found & fetched
  # All bikes
  expose(:bikes) do
    @bikes ||= ([bike] if record_found?(bike))
    @bikes ||= bikes_status_report.assets
    @bikes ||= Bike.eager_load(:bike_model,:hook_reservation, :hook, :assignment).all 
    @bikes
  end

  # The bike_form is action sensative, so it is defined
  # in each action. This expose give the view access to
  # the correct bike_form object
  expose(:bike_form) do
    @bike_form ||= BikeForm.new(bike, bike_form_params)
    @bike_form
  end

  # Fetch by
  # * bike's hook if bike is fetched
  # * hook_id if specified
  expose(:hook) do
    @hook ||= (bike.hook if bike)
    @hook ||= (Hook.find_by_id(params[:hook_id]) if params[:hook_id])
  end
  
  # Fetch by:
  # * bike's reservation
  # * New with the next available hook
  expose :hook_reservation do
    @hook_reservation = bike.hook_reservation if bike
    @hook_reservation ||= HookReservation.new(:bike => bike, :hook => Hook.next_available)
  end
  
  # Exposed to specify object to build new comments on
  expose(:commentable) do
    @commentable ||= bike
  end

  # Provide data that can be interpolated
  # into page title strings
  expose :title_data do
    {:bike_number => bike.number.to_s}
  end

  def index
    authorize! :read, Bike

    respond_to do |format|
      format.html
      format.csv { render :csv => bikes_status_report }
    end
  end

  def show
    authorize! :read, bike || Bike
    redirect_to root_path and return if fetch_failed? bike
  end

  def qr
    authorize! :read, bike || Bike
    redirect_to root_path and return if fetch_failed? bike
    respond_to do |format|
      @qr = RQRCode::QRCode.new(url_for(bike), :size => 7)
      format.html
    end
  end

  def new
    authorize! :create, Bike
  end

  def create     
    authorize! :create, Bike
    if verify_signatory && bike_form.save
      flash[:success] = I18n.translate('controller.bikes.create.success')
      redirect_to bike_post_created_path and return
    end
    render :new
  end

  def edit
    authorize! :edit, bike || Bike
    redirect_to root_path and return if fetch_failed?(bike)
  end

  def update
    authorize! :edit, bike || Bike
    redirect_to root_path and return if fetch_failed?(bike)
    redirect_to bike and return unless verify_signatory
    if bike_form.save
      flash.now[:success] = I18n.translate('controller.bikes.update.success')
      redirect_to bike and return
    end

    render 'edit'
  end
  
  def destroy
    authorize! :destroy, bike || Bike
    redirect_to root_path and return if fetch_failed?(bike)

    if bike.destroy
      flash[:success] = I18n.translate('controller.bikes.destroy.success')
    else
      flash[:error] = I18n.translate('controller.bikes.destroy.fail')
      redirect_to bike and return
    end

    redirect_to root_path
  end


  private

  # Protect from mass assignment
  # See https://gist.github.com/1975644
  # http://rubysource.com/rails-mass-assignment-issue-a-php-perspective/
  def bike_form_params
    params[:bike_form].slice(*BikeForm.form_params_list) if params[:bike_form]
  end

  # Allow for the option to "Creat and add another" 
  # record by redirecting to the new page instead of
  # the show page for the record
  def bike_post_created_path
    if params[:commit]
      path = (params[:commit].downcase == I18n.translate('commit_btn.new_plus').downcase) ?
      new_bike_path : bike_path(bike_form.bike)
    end
    path || root_path
  end # def bike_post_created_path

  def bikes_status_report
    if params[:status]
      case params[:status]
      when 'available'
        BikeReport.new(:available => true)
      when 'assigned'
        BikeReport.new(:assigned => true, :present => true)
      when 'departed'
        BikeReport.new(:departed => true)
      end
    else
      BikeReport.new
    end
  end # bikes_status_report

end
