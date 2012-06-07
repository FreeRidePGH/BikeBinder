module ProjectsHelper

  def inspection_status(project, inspection, user=nil)
    # The inspection can pass?
    can_pass = Inspection.pass?(inspection)

    # The inspection can fail?
    can_fail = Inspection.fail?(inspection)

    # The inspection can be resumed by user?
    user_inspection = project.detail.user_inspection(user)

    can_edit = (inspection && user_inspection) && (inspection.id == user_inspection.id)

    return {:can_pass => can_pass, :can_fail => can_fail, :can_edit => can_edit}
  end

  def print_inspection_status(project, inspection, user=nil)
    status = inspection_status(project, inspection, user)
    p = ""
    p << "Passing" if status[:can_pass]
    p << "Failing" if status[:can_fail]
    p << "Incomplete" if !(status[:can_pass] || status[:can_fail])
    #p << "|" unless p.empty?
    p << " | " << link_to("Resume", project.detail.inspection_hash(inspection, user)) if status[:can_edit]
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
