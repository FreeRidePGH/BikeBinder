module TimeEntryActions

  def self.included(base)

    # Build a new time entry
    base.expose(:time_entry) do
      args = params[:time_entry]

      if @t_ret.nil?
        default_end = DateTime.now
        default_start = default_end - 1.hour
        entry_opts = {}
        entry_opts[:obj] = time_trackable
        entry_opts[:user_id] = current_user.id if current_user

        if args
          arg_end = args[:ended_on] 
          arg_start =  args[:started_on]
          entry_opts[:start] = arg_start unless arg_start.blank?
          entry_opts[:end] =  arg_end unless arg_end.blank?
          entry_opts[:description] = args[:description] 
        end

        # Apply default values conditionally
        entry_opts[:end] ||= default_end.strftime("%m/%d/%Y %l:%M %p")
        entry_opts[:start] ||= default_start.strftime("%m/%d/%Y %l:%M %p")

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

  def time_trackable_title
    "#{time_trackable.class.to_s.humanize} #{time_trackable.friendly_id}"
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
