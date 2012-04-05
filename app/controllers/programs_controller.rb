class ProgramsController < ApplicationController
  
  expose(:category)do
    cat_id = :project_category_id
    @cat ||= (ProjectCategory.find(params[cat_id]) if params[cat_id])
  end

  expose(:program) do
    @prog ||= (Program.find(params[:id]) if params[:id])
    @prog ||= (category.programs.build(params[:program]) if category)
    @prog ||= Program.new(params[:program])
  end

  # Scope projects by
  # * Projects under a program when a program is fetched
  expose(:projects) do
    @proj_scope ||= (program.projects if program)
  end

  def index
  end

  def new
  end

  def create
    if program and program.save 
      redirect_to program_path(program) and return
    else
      render 'new'
    end
  end

  def show
    if request.path != program_path(program)
      # In case we got here from a prev friendly_id history url
      redirect_to program, status: :moved_permanently
    end
  end

  def edit
  end

  def update
  end

end

