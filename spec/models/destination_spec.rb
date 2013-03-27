require 'spec_helper'

describe Destination do

  context "with unique name and label" do
    subject(:dest){FactoryGirl.create(:destination)}
    it "is valid" do
      expect(dest).to be_valid
    end
  end

end
