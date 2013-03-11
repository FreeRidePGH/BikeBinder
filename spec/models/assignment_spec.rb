require 'spec_helper'

describe Assignment do

  context "without bike" do
    let(:program){FactoryGirl.create(:program)}
    subject(:assignment){Assignment.build(:bike => nil, :program => program)}

    it "is not valid" do
      expect(assignment).to_not be_valid
    end
  end
  
  context "without a program" do
    let(:bike){FactoryGirl.create(:bike)}
    subject(:assignment){Assignment.build(:bike => bike, :program => nil)}

    it "is not valid" do
      expect(assignment).to_not be_valid
    end
  end

  describe "build with empty params" do
    subject(:assignment){Assignment.build({})}
      
    it "is not valid" do
      expect(assignment).to_not be_valid
    end
  end

  context "with a bike and program" do
    subject(:assignment){FactoryGirl.create(:assignment)}
    let(:bike){assignment.bike}
    
    it "is valid" do
      expect(assignment).to be_valid
    end

    it "assigns the bike" do
      expect(bike).to_not be_nil
    end

    it "assigns the bike to the program" do
      expect(bike.allotment.application).to_not be_nil
    end
  end # context "with a bike and program"

  describe "assigning a bike to a program" do
    let(:bike){FactoryGirl.create(:bike)}
    let(:program){FactoryGirl.create(:program)}
    subject(:assignment){Assignment.build(:bike => bike, :program => program)}

    before :each do
      assignment.save
    end

    it "is valid" do
      expect(assignment).to be_valid
    end

    it "references the bike" do
      expect(assignment.bike).to eq bike
    end

    it "assigns the bike to the program" do
      expect(bike.allotment.application).to eq(program)
    end
  end
  
end
