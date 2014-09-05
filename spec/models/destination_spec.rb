require 'spec_helper'

describe Destination do

  context "with unique name and label" do
    subject(:dest){FactoryGirl.create(:destination)}
    it "is valid" do
      expect(dest).to be_valid
    end
  end

  context "that is already assigned" do
    let(:assignment){FactoryGirl.create(:assignment_departed_dest)}
    subject(:bike){assignment.bike}

    it "departs the bike" do
      expect(bike).to be_departed
    end
    it "gives the assignment as destination" do
      expect(bike.application).to eq assignment.application
    end
  end #  context "with an assignment"


end
