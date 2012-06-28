class TimeEntriesController < ApplicationController

  def show
  end

  def enter
    @title = "Enter work hours"
  end

  def new
    @obj_class = scope.all.first.class.base_class
  end

  def create
    # Build the time entry and save

    # Handle successful save

    # Handle unsuccessful save
  end

  private

  # polymorphic controller
  # http://zargony.com/2008/05/16/sharing-controllers-and-views-with-polymorphic-resources

  def scope
    # search through the params hash for id
    pattern = /^.+_id$/
    params.each do |p|
      if (p[0] =~ pattern) == 0
        @scope = p[0][0...-3].classify.constantize
      end
    end
    return @scope
  end

end
