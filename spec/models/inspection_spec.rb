require 'spec_helper'

describe Inspection do
  
  before(:each) do
    unless @proj
      d = FactoryGirl.build(:youth_detail)
      @proj = d.proj
      @proj.detail = d
      
      
    end
  end

  describe "Completion" do
    
    it "should not be complete when first created" do
      @proj.detail.should be_inspection_complete
    end

  end

end
# == Schema Information
#
# Table name: projects
#
#  id                  :integer         not null, primary key
#  type                :string(255)
#  prog_id             :integer
#  prog_type           :string(255)
#  label               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  closed_at           :datetime
#  project_category_id :integer
#  state               :string(255)
#  completion_state    :string(255)
#

