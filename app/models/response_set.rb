class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods

  # Polymorphic association with bike/project/generic object
  has_one :subject, :as => :survey_response

  def title
    # Call surveyable.to_param to get friendly ID/Slug
    # Call surveyable.type/class to see what type of object is associated
  end
end
