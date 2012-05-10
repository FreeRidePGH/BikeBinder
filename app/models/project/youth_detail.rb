class Project::YouthDetail < ProjectDetail
  state_machine :initial => :under_repair do

    after_transition (any-:done) => :done, :do => "proj.close"

    event :mark_for_inspection do
      transition :under_repair => :ready_for_inspection
    end

    event :pass_inspection do
      transition :ready_for_inspection => :ready_for_program, :if => :pass_inspection?
    end

    event :fail_inspection do
      transition [:ready_for_inspection, :ready_for_program] => :under_repair
    end

    event :select_for_class do
      transition :ready_for_program => :class_material
    end

    event :remove_from_class do
      transition :class_material => :ready_for_program
    end
    
    event :finish do
      transition :class_material => :done, :if => :pass_req?
    end

    state :under_repair
    state :ready_for_inspection
    state :ready_for_program
    state :class_material
    state :done

  end

  def pass_req?
    self.class_material?
  end

  def pass_inspection?
    true
  end

end
