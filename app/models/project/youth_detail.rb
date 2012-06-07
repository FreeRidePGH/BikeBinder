class Project::YouthDetail < ProjectDetail

  include Inspection
  
  INSPECTION_TITLE = "Bike Overhaul Inspection"

  has_many :inspections, :class_name=>'ResponseSet', :as => :surveyable_process

  state_machine :initial => :under_repair do

    after_transition (any-:inspected) => :inspected, :do => :start_inspection_action
    after_transition :inspected => :inspected, :do => :resume_inspection_action

    ###################
    ## Inspection logic

    event :mark_for_inspection do
      transition :under_repair => :ready_to_inspect
    end

    event :start_inspection do
      transition :ready_to_inspect => :inspected
      transition :inspected => :inspected
    end

    event :resume_inspection do
      transition :inspected => :inspected
    end

    event :pass_inspection do
      transition :inspected => :ready_for_program, :if => :pass_inspection?
    end

    event :fail_inspection do
      transition :inspected => :under_repair, :if => :fail_inspection?
    end

    event :reinspect do
      transition [:ready_for_program, :class_material] => :inspected
    end
    
    ## End inspection logic
    #######################

    event :select_for_class do
      transition :ready_for_program => :class_material
    end

    event :remove_from_class do
      transition :class_material => :ready_for_program
    end

    state :under_repair
    state :ready_to_inspect
    state :inspected do
      def process_hash
        self.inspection_hash
      end
      def user_can?(user, action)
        case action
        when :start_inspection
          return user_inspection(user).nil?
        when :resume_inspection
          return user_inspection(user)
        else
          return true
        end
      end
    end
    state :ready_for_program
    state :class_material

    ########################################################
    ## Implementation for the project detail interface
    ##
    
    # Check projects to ensure they are open
    before_transition :do => :proj_must_be_open
    # Force projects to close on finish action
    after_transition (any-:done) => :done, :do => "proj.close"

    # Required transition to done state
    # Must be the last transition in order for done to be
    # lowest priority in states list
    event :finish do
      transition :class_material => :done, :if => :pass_req?
      #transition :class_material => :done, :if => current_user.admin?
    end

    # Required implementation of done state
    state :done
    ##
    #######################################################
  end

  def pass_req?
    self.class_material?
  end

  # TODO inspection on a per-user basis
  # TODO history of inspections


  # TODO Modularize inspection logic in a mixin

  def surveyable_context
    proj
  end

  private

  def self.inspection_survey_code
    survey = SurveyorUtil.find(INSPECTION_TITLE)
    survey.access_code if survey
  end


end
# == Schema Information
#
# Table name: project_youth_details
#
#  id                     :integer         not null, primary key
#  proj_id                :integer
#  proj_type              :string(255)
#  state                  :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  inspection_access_code :string(255)
#

