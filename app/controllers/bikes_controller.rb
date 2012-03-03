class BikesController < ApplicationController
  def new
    
  end

  def show
    fetch_bike
    @hook = Hook.find_by_bike_id(nil)
    @notes = @bike.comment_threads
    @comment = Comment.build_from(@bike, current_user, "")
  end

  def index
    @title = "Bikes Index"
    @bikes = Bike.all
  end

  def create
  end

  def edit
    @title = "Edit Bike"
    fetch_bike
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
    fetch_bike
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

  def free_hook
    fetch_bike
    @hook = @bike.hook

    @hook.bike = nil
    @hook.save

    @bike.hook = nil
    @bike.save

    redirect_to @bike
  end

  def reserve_hook
    fetch_bike

    @hook = Hook.find_by_bike_id(nil)
    @bike.hook = @hook
    @bike.save
    
    redirect_to @bike
  end


  # Helper method that assigns the bike or redirects if invalid
  def fetch_bike
    @bike = Bike.find(params[:id])
    if @bike
      @title = "Bike Information for" + @bike.number.to_s
    else
      redirect_to bikes_path
    end
  end

end
