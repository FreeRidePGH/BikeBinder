module TimeEntryActions

  def self.included(base)

    # Build a new time entry
    base.expose(:time_entry) do
      if @t_ret.nil?
        entry_opts = {}
        entry_opts[:obj] = time_trackable
        entry_opts[:user_id] = current_user.id if current_user
        entry_opts[:time_start] = DateTime.now
        entry_opts[:time_end] = DateTime.now
        entry_opts[:description] = params[:time_entry][:description] if params[:time_entry]
        @t_ret = (TimeEntry.build_from(entry_opts) if time_trackable)
      end
      @t_ret
    end 

  end #self.included

  # Default url for actions to redirect to
  # Override to change behaviour
  def time_trackable_url
    url_for(time_trackable)
  end


  def show
  end

  def new
    @title = "Enter work hours"
    puts @title
    puts time_trackable.nil?
    render 'time_entries/new'
  end

  def create
    @title = "Enter work hours"
    if time_trackable
      if time_entry && time_entry.save
        # Handle successful save        
        flash[:success] = "Your time was entered successfully"
      else
        # Handle unsuccessful save
        flash[:error] = {:description => "Oops! No time entry was logged."}
        time_entry.errors.each do |key, val|
          flash[:error][("message_#{key.to_s}").to_sym]= "#{key.upcase.to_s} #{val}"
        end
        render 'time_entries/new' and return
      end #if time_entry.save
    end #if time_trackable
    redirect_to time_trackable_url
  end

end
