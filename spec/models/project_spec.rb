# == Schema Information
#
# Table name: projects
#
#  id               :integer         not null, primary key
#  category         :string(255)
#  projectable_id   :integer
#  projectable_type :string(255)
#  bike_id          :integer
#  label            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Project do
  pending "add some examples to (or delete) #{__FILE__}"
end
