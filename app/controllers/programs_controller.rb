class ProgramsController < ApplicationController
  def index
    @programs = Program.all
  end

  def new
    @program = Program.new
  end

  def create
    @category = ProjectCategory.find(params[:project_category_id])
    @program = @category.programs.build(params[:program]) if @category
    if @program and @program.save 
      redirect_to program_path(@program) and return
    else
      render 'new'
    end
  end

  def show
    @program = Program.find(params[:id])

    if request.path != program_path(@program)
      # In case we got here from a prev friendly_id history url
      redirect_to @program, status: :moved_permanently
    end

    @projects = @program.projects
  end

end

