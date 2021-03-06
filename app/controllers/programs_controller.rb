class ProgramsController < ApplicationController
  
  expose(:category)do
    cat_id = :project_category_id
    @cat ||= (ProjectCategory.find(params[cat_id]) if params[cat_id])
  end

  expose(:program) do
    @prog ||= (Program.find(params[:id]) if params[:id])
    @prog ||= Program.new(program_params)
  end

  def index
    @title = "Programs"
  end

  def new
    @title= "Create new Program"
  end

  def create
    if program and program.save 
      redirect_to program_path(program) and return
    else
      render 'new'
    end
  end

  def show
    @bikes = program.bikes
    @title = "Program Information"
    if request.path != program_path(program)
      # In case we got here from a prev friendly_id history url
      redirect_to program, status: :moved_permanently
    end
  end

  def edit
    @title = "Edit Program"
  end

  def update
  end

  private

  def program_params
    params[:program].slice(:title, :max_total, :max_open) if params[:program]
  end

end

