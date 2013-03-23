class AssignmentsController < ApplicationController

  expose(:assignment) do
    unless params[:id].blank?
      @asmt ||= Assignment.where{id=my{params[:id]}}.first
    end
    @asmt
  end
  
  # POST
  def create
    (redirect_to root_path and return) if fetch_failed?([bike, program])
    
    if Assignment.build(:bike => bike, :program => program).save
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
  end
  
  # DELETE
  def destroy
    bike = assignment.bike if assignment
    (redirect_to root_path and return) if fetch_failed?([assignment, bike])
    
    if !bike.departed? && assignment.delete
      flash[:success] = I18n.translate('controller.assignments.destroy.success', :bike => bike.number)
    else
      flash[:error] = I18n.translate('controller.assignments.destroy.fail', :bike => bike.number)
    end

    redirect_to bike
  end

end # class AssignentsController
