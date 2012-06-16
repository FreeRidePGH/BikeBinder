require 'spec_helper'

describe Project::Youth do

  before(:each) do
    unless @p
      d = FactoryGirl.build(:youth_detail)
      @p = d.proj
      @p.detail = d
    end
  end

  describe "Steps" do
    
    it "should be 'open' first started" do
      @p.should be_open
    end

  end
  
end
