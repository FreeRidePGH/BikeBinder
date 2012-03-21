class ProgramsController < ApplicationController
  def index
    @programs = Program.all
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

