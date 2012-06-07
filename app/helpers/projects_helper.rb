module ProjectsHelper

  def inspection_status(project, inspection, user=nil)
    # The inspection can pass?
    can_pass = Inspection.pass?(inspection)

    # The inspection can fail?
    can_fail = Inspection.fail?(inspection)

    # The inspection can be resumed by user?
    # Check the following:
    #   user_inspection is found
    #     found inspection is valid
    #     found inspection matches specified inspection
    user_inspection = project.detail.user_inspection(user, :valid_only => true)
    can_edit = (inspection && user_inspection) && (inspection.id == user_inspection.id)

    # Specify if the inspection is old
    old = project.detail.old_inspection?(inspection)

    return {:can_pass => can_pass, :can_fail => can_fail, :can_edit => can_edit, :is_old => old}
  end

  def print_inspection_status(project, inspection, user=nil)
    status = inspection_status(project, inspection, user)
    p = ""
    view_args = project.detail.inspection_hash(inspection, user)
    view_args[:action] = :show
    if status[:is_old]
      p << link_to("Old inspection", view_args)
    else
      status_text = "Passing" if status[:can_pass]
      status_text = "Failing" if status[:can_fail]
      status_text = "Incomplete" if !(status[:can_pass] || status[:can_fail])
      p << link_to(status_text, view_args)

      if status[:can_edit]
        p << " | " 
        p << link_to("Resume", project.detail.inspection_hash(inspection, user))
      end
    end

    return p.html_safe
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
