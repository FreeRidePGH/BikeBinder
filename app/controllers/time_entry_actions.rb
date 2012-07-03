module TimeEntryActions

  def show
  end

  def new
    @title = "Enter work hours"    
    puts @title
    puts time_trackable.nil?
    render 'time_entries/new'
  end

  def create
    # Build the time entry and save

    # Handle successful save

    # Handle unsuccessful save
    flash[:error] = "No time entry logged."

    redirect_to time_trackable_url
  end

end
