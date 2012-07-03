class ProjectTimeEntriesController < ApplicationController

  include ProjectsExposure

  expose(:time_trackable) do
    @ttrack ||= project.detail if project
  end

  include TimeEntryActions

  def time_trackable_url
    url_for(project)
  end
    

end
