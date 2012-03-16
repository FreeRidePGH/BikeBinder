# == Schema Information
#
# Table name: projects
#
#  id               :integer         not null, primary key
#  project_category :string(255)
#  projectable_id   :integer
#  projectable_type :string(255)
#  bike_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Project do
  pending "add some examples to (or delete) #{__FILE__}"
end
