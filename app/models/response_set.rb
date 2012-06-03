class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods

  # Polymorphic association with bike/project/generic object
  belongs_to :surveyable, :polymorphic => true

  # Polymorphic association with a model that uses the survey
  # as part of business process or task
  belongs_to :surveyable_process, :polymorphic => true

  def title
    # Call surveyable.to_param to get friendly ID/Slug
    # Call surveyable.type/class to see what type of object is associated
  end
end
# == Schema Information
#
# Table name: response_sets
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  survey_id        :integer
#  access_code      :string(255)
#  started_at       :datetime
#  completed_at     :datetime
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  api_id           :string(255)
#  surveyable_id    :integer
#  surveyable_type  :string(255)
#  biz_process_id   :integer
#  biz_process_type :string(255)
#

