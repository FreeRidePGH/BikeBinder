class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods

  # Polymorphic association with bike/project/generic object
  belongs_to :surveyable, :polymorphic => true

  #attr_accessable surveyalbe

  def title
    # Call surveyable.to_param to get friendly ID/Slug
    # Call surveyable.type/class to see what type of object is associated
  end
end
