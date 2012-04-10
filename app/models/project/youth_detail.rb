class Project::YouthDetail < ProjectDetail

  state_machine :initial => :under_repair do

    event :mark_for_inspection do
      transition :under_repair => :ready_for_inspection
    end

    event :inspect do
      transition :ready_for_inspection => :ready_for_program, :if => :inspection_passed?
      transition :ready_for_inspection => :under_repair
    end

    event :select_for_participant do
      transition :ready_for_program => :class_material
    end

    state :under_repair
    state :ready_for_inspection
    state :ready_for_program
    state :class_material

  end

  def pass_req?
    self.class_material?
  end

  def send_event(e=nil)
    self.((e.to_s).constantize) if e
  end

end
