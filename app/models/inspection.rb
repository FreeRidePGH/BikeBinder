# -*- coding: utf-8 -*-
require "surveyor_util"

module Inspection

  # NOTES for implementation: 
  # 1. Include the module AFTER the state_machine definition in the class
  #    (Also, after the detail states module is included)
  # 2. Add column to project detail to hold the inspection access code
  #
  def self.included(base)
    base.extend(ClassMethods)
  end

  module InstanceMethods
  
    def surveyable_context
      if self.inspection_context.blank?
        return self
      else
        return self.send(self.inspection_context.to_sym)
      end
    end

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
  
    def valid_inspection?(insp)
      old = insp && old_inspection?(insp)
      return !old
    end

    # When the transition to :inspected state occured
    def inspected_at?
      transitions = self.transitions
      context = transitions[:inspected]
      
      return context[:origin].created_at unless context[:origin].nil?
      return nil
    end

    # An inspection is old if it was started before the most recent
    # transition to the :inspected state
    def old_inspection?(insp)
      inspected_at = self.inspected_at? if self.inspected?
      return (inspected_at.nil?) ? true : insp.started_at < inspected_at
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
  
    # Get the inspection associated with the given user
    # Specify :valid_only=>true to only return an inspection
    # if it is valid
    def user_inspection(uid=nil, opts={})
      uid ||= uid.id if (uid && uid.respond_to?('id'))
      insp = inspections.where{user_id == uid}.first
      
      if(opts[:valid_only])
        return self.valid_inspection?(insp) ? insp : nil
      end
      return insp

    end

    def inspectable
      scope = self.surveyable_scope
      return (scope.nil?) ? self : self.rsend(scope.split('.'))
    end

    # http://csummers.com/2007/01/18/ruby-recursive-send/
    def rsend(*args, &block)
      obj = self
      args.each do |a|
        b = (a.is_a?(Array) && a.last.is_a?(Proc) ? a.pop : block)
        obj = obj.__send__(*a, &b)
      end
      obj
    end
    alias_method :__rsend__, :rsend

    private

    #extract the user object from the args
    def action_user(transition)
      args = transition.args
      
      if args.nil? || args[0].nil?
        return nil
      end
      
      return args[0][:user]
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
      @survey = SurveyorUtil.find(self.class.inspection_title)
    
      if @survey
        # Build the response set
        uid ||= user.id if user
        @response_set = ResponseSet.create(:survey => @survey, 
                                           :user_id => uid,
                                           :surveyable_type => self.inspectable.class.to_s,
                                           :surveyable_id => self.inspectable.id,
                                           :surveyable_process_type => self.class.to_s,
                                           :surveyable_process_id => self.id)
        if @response_set
          # Assign to this project
          self.inspections << @response_set
          self.inspection_access_code = @response_set.access_code
          self.save
        end
      end  # @survey 
      # TODO: Error and stop transition if the inspection can not be made?
    end #start inspection action

  end #InstanceMethods

  # To include class methods in your models, you’ll want to 
  # follow the convention of creating a nested module and 
  # extend base in the included method.
  # http://alexanderwong.me/post/15697487692/rails-model-mixins-via-included-modules
  # =================
  # = Class Methods =
  # =================
  module ClassMethods
    def has_inspection(options={}, base=nil)
      
      base ||= self
      
      # Lazily include the instance methods so we don't clutter up
      # any more models than necessary
      base.send(:include, InstanceMethods)
      
      # http://teachmetocode.com/articles/ruby-on-rails-polymorphic-associations-with-mixin-modules/
      base.instance_eval("has_many :inspections, :class_name=>'ResponseSet', :as => :surveyable_process")

      base.send(:class_attribute, :surveyable_scope)
      base.surveyable_scope = options[:inspectable]
      
      base.send(:class_attribute, :inspection_context)
      base.inspection_context = options[:context_scope]

      base.send(:class_attribute, :inspection_title)
      base.inspection_title = options[:title]

      machine = base.state_machine

      machine.state :ready_to_inspect
      machine.state :inspected do
        def process_hash
          # transition to the inspection page
          self.inspection_hash
        end
        def user_can?(user, action)
          case action
          when :start_inspection
            return user_inspection(user, :valid_only => true).nil?
          when :resume_inspection
            return user_inspection(user, :valid_only => true)
          else
            return true
          end
        end
      end

      machine.after_transition (machine.any-:inspected) => :inspected, 
      :do => :start_inspection_action

      machine.after_transition :inspected => :inspected, 
      :do => :resume_inspection_action

      ###################
      ## Inspection state transition (event) logic
      start_state = options[:start_point]
      end_state = options[:end_point]

      machine.event :mark_for_inspection do
        transition start_state => :ready_to_inspect
      end

      machine.event :fail_inspection do
        transition :inspected => start_state, :if => :fail_inspection?
      end

      machine.event :pass_inspection do
        transition :inspected => end_state, :if => :pass_inspection?
      end

      machine.event :reinspect do
        transition options[:reinspectable] => :inspected
      end

      machine.on :start_inspection do
        transition :ready_to_inspect => :inspected
        transition :inspected => :inspected
      end

      machine.event :resume_inspection do
        transition :inspected => :inspected
      end
      ## End inspection logic
      #######################
    end # has_inspection

    def inspection_survey_code
      survey = SurveyorUtil.find(self.inspection_title)
      survey.access_code if survey
    end


  end

end #ClassMethods

