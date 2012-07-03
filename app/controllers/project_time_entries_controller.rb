class ProjectTimeEntriesController < ApplicationController
  include ProjectsExposure

  expose(:time_trackable) do
    @ttrack ||= project.detail if project
  end

  include TimeEntryActions

  expose(:time_trackable_url) do
    url_for(project)
  end

  expose(:time_trackable_title) do
    "#{project.category_name} Project for bike #{project.bike.number}" if project
  end
end
