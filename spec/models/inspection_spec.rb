require 'spec_helper'

class TestDetail < ProjectDetail
  self.table_name = "project_youth_details"

  state_machine :initial => :state_0 do
    state :state_0
    state :state_1
  end # state_machine

  has_inspection(
                 :title => "Bike Overhaul Inspection",
                 :start_point => :state_0,
                 :end_point => :state_1,
                 :reinspectable => [:state_1]
                 )
  #include ProjectDetailStates

  def pass_req?; false end
end

describe Inspection do

  # http://www.mail-archive.com/rspec-users@rubyforge.org/msg16199.html
  # http://stackoverflow.com/questions/3127069/how-to-dynamically-alter-inheritance-in-ruby
  let(:class_with_inspection){TestDetail.new }

  subject {class_with_inspection}
  
  before(:each) do
    unless false && @proj
      d = FactoryGirl.build(:youth_detail)
      @proj = d.proj
      @proj.detail = d
    end
  end

  describe "Class properties" do

    it "should have survey code" do
      str2 = TestDetail.inspection_survey_code
      str2.should_not be_nil

      proj = class_with_inspection
      str1 = proj.class.inspection_survey_code
      str1.should_not be_nil
    end

  end

  describe "Completion" do
    
    it "should not be complete when first created" do
      proj = class_with_inspection
      proj.state.should eq("state_0") #inspection_complete
    end

    it "should not have any inspections at first" do
      proj = class_with_inspection
      proj.should_not be_inspected
    end

  end

  describe "Starting an inspection" do
    
    it "should have inspection when starting" do
      proj = class_with_inspection

      proj.mark_for_inspection
      proj.should be_ready_to_inspect

      proj.start_inspection      
      proj.should be_inspected
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

