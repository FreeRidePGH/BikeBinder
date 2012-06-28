class TimeEntry < ActiveRecord::Base

  class Category < ActiveRecord::Base
    self.table_name = "time_entry_categories"
    has_many :time_entries, :as => :context
    attr_accessible :title

    def to_s
      self.title
    end
  end

  acts_as_nested_set :scope => [:time_trackable_id, :time_trackable_type]

  validates_presence_of :description
  validates_presence_of :user
  #validates_presence_of :started_on
  #validates :ended_on, :presence => true

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  belongs_to :time_trackable, :polymorphic => true

  # Building a time entry with a context reference
  # provides a way to define complex metadata
  # and additional behaviour
  belongs_to :context, :polymorphic => true

  # NOTE: Time Entries belong to a user
  belongs_to :user

  def self.build_category(opts={})
    c = Category.new
    c.title = opts[:title]
    return c
  end

  def self.get_category(str)
    # Check if the category exists
    c = Category.find_by_title(str)
    if c.nil?
      # Category not found
      # Make a new category
      c = build_category(:title=>str)
    end
    c.save
    return c
  end

  # Helper class method that allows you to build an entry
  # by passing a time trackable object, a user_id, description text
  # and start and end times and optional context
  # example in readme
  def self.build_from(opts={})
    
    started_on = opts[:start]
    ended_on = opts[:end]
    built_on = Time.now
    started_on ||= built_on
    ended_on ||= built_on

    obj = opts[:obj]
    user_id = opts[:user_id]
    comment = opts[:description]

    ctxt = opts[:context]
    
    if ctxt && (ctxt.class == String)
      str = ctxt
      ctxt = get_category(str)
    end
    
    c = self.new

    if obj
      c.time_trackable_id = obj.id
      c.time_trackable_type = obj.class.base_class.name
    end

    c.description = comment
    c.user_id = user_id
    c.started_on = started_on
    c.ended_on = ended_on    

    if ctxt
      c.context_id = ctxt.id
      c.context_type = ctxt.class.base_class.name
    end
    
    c
  end

  #helper method to check if an entry has children
  def has_children?
    self.children.size > 0
  end

  # Helper class method to lookup all entries assigned
  # to all time trackable types for a given user.
  scope :find_time_entries_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all entries for
  # time trackable class name and time trackable id.
  scope :find_time_entries_for_time_trackable, lambda { |time_trackable_str, time_trackable_id|
    where(:time_trackable_type => time_trackable_str.to_s, :time_trackable_id => time_trackable_id).order('created_at DESC')
  }

  # Helper class method to look up a time_trackable object
  # given the time_trackable class name and id
  def self.find_time_trackable(time_trackable_str, time_trackable_id)
    time_trackable_str.constantize.find(time_trackable_id)
  end

  def f_date(datetime)
     return datetime.localtime.strftime("%A %-m/%-e/%Y")
  end
  def date_start
    return f_date(started_on)
  end
  def date_end
    return f_date(ended_on)
  end

  #returns the duration in hours
  def hours    
    return (ended_on - started_on)/60.0/60.0
  end
  
  def duration_text
    duration_min = ((end_time - start_time)/60.0).round
    if duration_min < 60
      return "#{duration_min} minutes"
    elsif duration_min % 60 == 0
      return "#{duration_min/60} hours"
    else
      return "#{duration_min/60} hours, #{duration_min%60} minutes"
    end
  end
  
  def f_time(datetime)
    return datetime.localtime.strftime("%I:%M %p")
  end
  def time_start
    return f_time(started_on)
  end
  def time_end
    return f_time(ended_on)
  end

end
