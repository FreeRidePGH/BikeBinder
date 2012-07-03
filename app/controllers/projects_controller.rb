class ProjectsController < ApplicationController

  include ProjectsExposure

  def index
    @title = "Projects#index"
  end

  def show
    redirect_to root_path and return unless project

    if project.closed? 
      @title = "Project details (Closed)"
    else 
      @title =  "Project details"
    end
  end

  def new
    @title = "Create new project"
  end

  def create
    if project and project.assign_to(params)
      if project.save
        flash[:success] = "Bike was assigned to #{project.prog.title}"
        
        if project.terminal?
          redirect_to project.bike and return
        else
          redirect_to project_path(project) and return
        end
      else
        flash[:error] = {:issue => "Error saving project"}
        project.errors.messages.each do |k, val|
          flash[:error][k] = "#{k} #{val[0]}".humanize
        end
      end
    else
      flash[:error] = "Bike could not be assigned to a new project"
    end

    #render 'new'
    redirect_to root_path
  end

  def update
    # TODO updating and saving project details
    # Save the project details and the project
    render 'show'
  end

  def transition
    prefix = project.type.downcase.gsub("::", "_")
    proj_key = prefix.to_sym
    details_key = "#{prefix}_detail".to_sym

    # Call the detail event with parameters
    call_event(project.detail, details_key)

    # Call the project event with parameters
    call_event(project, proj_key)

    # TODO sucess message when transition occurs
    
    # TODO helper function that parses errors and adds to the flash
    # check for errors
    project.errors.messages.each do |key, val|
      flash[:error] ||= {}
      flash[:error][("message_#{key.to_s}").to_sym]= "#{key.upcase.to_s} #{val}"
    end
    project.detail.errors.messages.each do |key, val|
      flash[:error] ||= {}
      flash[:error][("message_#{key.to_s}").to_sym]= "#{key.to_s.humanize.upcase}: #{val[0]}"
    end
    
    if project.process_hash
      redirect_to project.process_hash and return
    else
      redirect_to project and return
    end
  end

  def destroy
    # TODO project cancel process
    if project and project.cancel
      flash[:success] = "Project was canceled for bike #{bike.number}."
      redirect_to bike_path(bike) and return
    end
    
    flash[:error] = "Project could not be found or canceled."
    render 'show'
  end

  private

  def project_params
    params[:project].slice() if params[:project]
  end

  def call_event(obj, key)
    if params[key]
      event = params[key][:state_events]
      if event
        opts = {:user => current_user}
        args = params[key][:event_args]
        opts = opts.merge(args) if args
        obj.send(event, opts)
      end
    end
  end

end
