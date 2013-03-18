class BikesController < ApplicationController
  
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
    @bikes ||= Bike.all 
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
  # * next available from the Hook model
  expose(:hook) do
    @hook ||= (bike.hook if bike)
    @hook ||= (Hook.find_by_id(params[:hook_id]) if params[:hook_id])
    @hook ||= Hook.next_available
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
    @brands = nil
    @colors = ColorNameI18n::keys
    @searchTerm = params[:search]
  end

  def show
    @program = Program.new
    redirect_to bikes_path and return if fetch_failed?bike
  end

  def new
  end

  def create     
    if bike_form.save
      flash[:success] = I18n.translate('controller.bikes.create.success')

      if params[:commit]
        path = (params[:commit].downcase == I18n.translate('commit_btn.new_plus').downcase) ?
        new_bike_path : bike_path(bike_form.bike)
      end
      path ||= root_path
      
      redirect_to path and return
    end
    render :new
  end

  def edit
    redirect_to bikes_path and return if fetch_failed?(bike)
  end

  def update
    redirect_to bikes_path and return if fetch_failed?(bike)

    if bike_form.save
      flash.now[:success] = I18n.translate('controller.bikes.update.success')
      redirect_to bike and return
    end

    render 'edit'
  end
  
  def destroy
    redirect_to bikes_path and return if fetch_failed?(bike)

    if bike.destroy
      flash[:success] = I18n.translate('controller.bikes.destroy.success')
    else
      flash[:error] = I18n.translate('controller.bikes.destroy.fail')
      redirect_to bike and return
    end

    redirect_to bikes_path
  end


  private

  # Protect from mass assignment
  # See https://gist.github.com/1975644
  # http://rubysource.com/rails-mass-assignment-issue-a-php-perspective/
  def bike_form_params
    params[:bike_form].slice(*BikeForm.form_params_list) if params[:bike_form]
  end

end
