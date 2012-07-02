require 'spec_helper'

describe Project::Youth do

  before(:each) do
    unless @proj
      d = FactoryGirl.build(:youth_detail)
      @proj = d.proj
      @proj.detail = d
    end
  end

  describe "Steps" do
    it "should be 'open' on first started" do
      @proj.should be_open
    end
  end

end
