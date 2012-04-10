# == Schema Information
#
# Table name: programs
#
#  id                  :integer         not null, primary key
#  title               :string(255)
#  project_category_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#  cosed_at            :datetime
#  slug                :string(255)
#  max_open            :integer
#  max_total           :integer
#

require 'spec_helper'

describe Program do
  pending "add some examples to (or delete) #{__FILE__}"
end
