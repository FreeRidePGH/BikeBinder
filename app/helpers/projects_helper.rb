module ProjectsHelper
  
  def inspection_grade(inspection)
    str = "Pass" if Inspection.pass?(inspection)
    str ||= "Fail" if Inspection.fail?(inspection)
    str ||= "N/A"
    return str
  end #def grade

  def inspection_completion(project, inspection, user=nil)
    done = project.detail.inspection_complete?(inspection)

    str = "Finished" if done
    str ||= "Incomplete"
      
    return str
  end

  def inspection_response_status(project, inspection, user=nil)
    # The inspection can be resumed by user?
    # Check the following:
    #   user_inspection is found
    #     found inspection is valid
    #     found inspection matches specified inspection
    user_inspection = project.detail.user_inspection(user, :valid_only => true)
    can_edit = (inspection && user_inspection) && (inspection.id == user_inspection.id)
    
    # Specify if the inspection is old
    old = project.detail.old_inspection?(inspection)

    return {:can_edit => can_edit, :is_old => old}
  end #inspection_response_satus

  def print_inspection_response_status(project, inspection, user=nil)
    status = inspection_response_status(project, inspection, user)
    str = ""
    view_args = project.detail.inspection_hash(inspection, user)
    view_args[:action] = :show

    if status[:can_edit] && !status[:is_old]
      str << link_to("Resume inspection", 
                     project.detail.inspection_hash(inspection, user))        
    else
      str << link_to("View inspection", view_args)
    end
    return str.html_safe
  end


  def available_actions(project, user)
    # Get the list of events for the given project
    events = project.detail.state_events
    
    # Determine if an event is unavailable for the given user
    actions = []
    events.each do |e|
      actions << e if project.detail.user_can?(user, e)
    end

    return actions
  end

end
