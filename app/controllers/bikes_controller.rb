class BikesController < ApplicationController
  
  before_filter :fetch_bike, 
  :only => [:show, :edit,:update,
            :new_comment,
            :vacate_hook, 
            :reserve_hook]
  
  def new
    @bike = Bike.new()
  end

  def show
    @hook = Hook.find_by_bike_id(nil)
    @comment = Comment.build_from(@bike, current_user, "")
  end

  def index
    @title = "Bikes Index"
    @bikes = Bike.all
  end

  def create    
    @bike = Bike.new(params[:bike])
    render :new
  end

  def edit
    @title = "Edit Bike"
  end

  def update
    if @bike.update_attributes(params[:bike])
      flash[:success] = "Bike info updated"
      redirect_to @bike
    else
      @title = "Edit Bike"
      render 'edit'
    end
  end

  def new_comment
    @comment = Comment.build_from(@bike, current_user, 
                                  params[:comment][:body])
    if @comment.save
      # Handle a successful save
      flash[:success] = "Thank you for your comment"
    else
      # Failed save
      flash[:error] = "Could not add your comment"
    end
    redirect_to @bike
  end

  def vacate_hook
    if @bike.vacate_hook!
      flash[:success] = "Hook vacated"
    else
      flash[:error] = "Could not vacate hook"
    end

      redirect_to @bike
  end

  def reserve_hook
    if @bike.reserve_hook!
      flash[:success] = "Hook #{@bike.hook.number} reserved successfully"
    else
      flash[:error] = "Could not reserve the hook."
    end
    
    redirect_to @bike
  end


  private

  # Helper method that assigns the bike or redirects if invalid
  def fetch_bike
    @bike = Bike.find(params[:id])
    if @bike
      @title = "Bike Information for" + @bike.number.to_s
    else
      redirect_to bikes_path
    end
    @bikes = [@bike]
  end



end
