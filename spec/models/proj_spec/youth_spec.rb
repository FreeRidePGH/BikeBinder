# == Schema Information
#
# Table name: proj_spec_youths
#
#  id            :integer         not null, primary key
#  state         :string(255)
#  specable_id   :integer
#  specable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe ProjSpec::Youth do
  pending "add some examples to (or delete) #{__FILE__}"
end
