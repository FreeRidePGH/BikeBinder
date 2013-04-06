class AssignmentsController < ApplicationController

  expose(:assignment) do
    unless params[:id].blank?
      id = params[:id].to_i
      @asmt ||= Assignment.where(:id=>id).first
    end
    @asmt
  end
  
  # POST
  def create
    redirect_to root_path and return if fetch_failed?([bike, program])
    redirect_to bike and return unless verify_signatory

    authorize! :create, Assignment
    
    if Assignment.build(:bike => bike, :program => program).save
      hound_action bike, "assign_program,program,#{program.label}"
      hound_action program, "assign_bike,number,#{bike.number}"
      flash[:success] = I18n.translate('controller.assignments.create.success',
                                       :bike => bike.number,
                                       :program => program.name)
    else
      flash[:error] = I18n.translate('controller.assignments.create.fail', :bike => bike.number)
    end

    redirect_to bike
  end # def create

  # PUT
  def update
    (redirect_to root_path and return) if fetch_failed?([assignment])
    redirect_to assignment.bike || root_path

    authorize! :update, assignment
  end
  
  # DELETE
  def destroy
    bike = assignment.bike if assignment
    program = assignment.application if assignment
    redirect_to root_path and return if fetch_failed?([assignment, bike, program])
    redirect_to bike and return unless verify_signatory

    authorize! :destroy, assignment
    
    if !bike.departed? && assignment.delete
      hound_action bike, "cancel_assignment"
      hound_action program, "unassign_bike,number,#{bike.number}"
      flash[:success] = I18n.translate('controller.assignments.destroy.success', :bike => bike.number)
    else
      flash[:error] = I18n.translate('controller.assignments.destroy.fail', :bike => bike.number)
    end

    redirect_to bike
  end

end # class AssignentsController
