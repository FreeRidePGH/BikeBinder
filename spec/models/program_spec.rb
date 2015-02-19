require 'rails_helper'

RSpec.describe Program, :type=>:model do

  context "with unique name and label" do
    subject(:prog){FactoryGirl.create(:prog)}
    it "is valid" do
      expect(prog).to be_valid
    end
  end

  context "missing name and label" do
    subject(:prog){Program.new}
    it "is not valid" do
      expect(prog).to_not be_valid
    end
  end

  context "with the same name and label" do
    let(:prog0){FactoryGirl.create(:prog)}
    subject(:prog){Program.new(:name => prog0.name, :label => prog0.label)}
    it "is not be valid" do
      expect(prog).to_not be_valid
    end
  end

  describe "with a repeated name" do
    let(:prog0){FactoryGirl.create(:prog)}
    subject(:prog){Program.new(:name => prog0.name, :label => prog0.label+"label1")}
    it "is not be valid" do
      expect(prog).to_not be_valid
    end
  end

  describe "with a repeated label" do
    let(:prog0){FactoryGirl.create(:prog)}
    subject(:prog){Program.new(:name => prog0.name+"name1", :label => prog0.label)}
    it "is not be valid" do
      expect(prog).to_not be_valid
    end
  end
end
