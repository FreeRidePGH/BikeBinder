require 'rails_helper'

RSpec.describe Assignment, :type => :model do

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

  describe "build with empty params", :type=>:model do
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
      expect(bike.application).to_not be_nil
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
      expect(bike.application).to eq(program)
    end

    describe "assigned bike" do
      it "is not available" do
        expect(bike).to_not be_available
      end

      it "is not departed" do
        expect(bike).to_not be_departed
      end
    end
  end # describe "assigning a bike to a program"

  context "when a bike already assigned to a program" do
    let(:assignment0){FactoryGirl.create(:assignment)}
    let(:bike){assignment0.bike}

    describe "assigns the bike to a new program" do
      let(:program){FactoryGirl.create(:program)}
      subject(:assignment){Assignment.build(:bike => bike, :program => program)}

      before :each do
        assignment.save
        bike.reload
      end

      it "is not valid" do
        expect(assignment).to_not be_valid
      end

      it "does not associate a new assignment with the bike" do
        expect(bike.assignment).to_not eq assignment
      end
      
      it "keeps the old program" do
        expect(bike.application).to_not eq program
      end

      it "does not dissassociate the original assignment" do
        assignment0.reload
        expect(assignment0.bike).to_not be_nil
        expect(assignment0.bike).to eq bike
        expect(bike.assignment).to eq assignment0
      end
    end

  end
  
end
