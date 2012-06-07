module Inspection
  
  def Inspection.complete?(insp)
    insp && insp.mandatory_questions_complete?    
  end

  # Instance method mixed into a project detail
  def inspection_complete?(insp)
    Inspection.complete?(insp)
  end

  # Inspection is complete and all checks pass
  def Inspection.pass?(insp)
    Inspection.complete?(insp) && insp.correct?
  end

  # Inspection is complete but not all checks pass
  def Inspection.fail?(insp)
    Inspection.complete?(insp) && ! insp.correct?
  end

  def pass_inspection?(insp=nil)
    if insp
      return Inspection.pass?(insp)
    else
      pass = false
      inspections.each do |i|
        pass ||= Inspection.pass?(i)
      end
      return pass
    end
  end

  def fail_inspection?(insp=nil)
    if insp
      return Inspection.fail?(insp)
    else
      # search over collection
      failing = false
      inspections.each do |i|
        failing ||= Inspection.fail?(i)
      end
      return failing
    end
  end
  
  
  # Assumes a 1:1 between user and inspection
  def inspection_hash(inspection=nil, user=nil)
    inspection_access = inspection.access_code if inspection
    inspection_access ||= (user.nil?)?
      self.inspection_access_code :
      user_inspection(user).access_code

    h = {:controller => :surveyor, :action => :edit,
          :survey_code => self.class.inspection_survey_code,
          :response_set_code => inspection_access}
  end
  
  def user_inspection(uid=nil)
    uid ||= uid.id if (uid && uid.respond_to?('id'))
    inspections.where{user_id == uid}.first
  end

  private

  #extract the user object from the args
  def action_user(transition)
    args = transition.args
    if args
      return args[0][:user]
    else
      return nil
    end
  end

  # Case user has an inspection:
  # Set the inspection hash to correspond to given user
  # User does not have an inspection
  # Start inspection action
  def resume_inspection_action(transition)
    user = action_user(transition)
    
    inspection = user_inspection(user)

    if inspection
      self.inspection_access_code = inspection.access_code
      self.save
    else
      start_inspection_action(transition)
    end
  end

  # TODO inspection on a per-user basis
  def start_inspection_action(transition)
    user = action_user(transition)

    # If an inspection already exists for this user, remove it
    insp = user_inspection(user)
    self.inspections.delete(insp) if insp
    
    #proj.bike.inspection = nil
    #proj.bike.save

    # Find the right survey to use
    @survey = SurveyorUtil.find(self.class::INSPECTION_TITLE)
    
    if @survey
      # Build the response set
      uid ||= user.id if user
      @response_set = ResponseSet.create(:survey => @survey, 
                                       :user_id => uid,
                                       :surveyable_type => self.proj.bike.class.to_s,
                                       :surveyable_id => self.proj.bike.id,
                                       :surveyable_process_type => self.class.to_s,
                                       :surveyable_process_id => self.id)
      if @response_set
        # Assign to this project
        self.inspections << @response_set
        self.inspection_access_code = @response_set.access_code
        self.save
      end
    end

    # Error and stop transition if the inspection can not be made?
  end

end


# Association with bike

# Association with project

# Association with survey

# validate a 1:1 association with a user

# validate that a bike and project can only have 1 inspection for a given user

# pass?

# fail?

# complete?


