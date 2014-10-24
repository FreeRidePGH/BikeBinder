require 'rails_helper'

RSpec.describe BikeReport, :type=>:model do

  context "with a bike seeded" do
    let!(:bike){FactoryGirl.create(:bike)}
    
    context "with default options" do
      subject(:report){BikeReport.new}
      
      it "has assets" do
        expect(report.assets).to_not be_empty
      end

      it "has data" do
        expect(report.data).to_not be_empty
      end
    end # context "with default options"
  end # context "with a bike seeded"

  context "filtering an unused number" do
    let(:number){FactoryGirl.generate(:bike_number)}
    subject(:report){BikeReport.new(:number_record => number)}
      
    it "has no assets" do
      expect(report.assets).to be_empty
    end
  end

  context "when all bikes are assigned" do
    let(:assignment){FactoryGirl.create(:assignment)}    
    let!(:bike){assignment.bike}
    describe "filtering assigned" do
      subject(:report){BikeReport.new(:assigned => true)}
      it "has assets" do
        expect(report.assets).to_not be_empty
      end
      it "has data" do
        expect(report.data).to_not be_empty
      end
      
      context "when bikes are present" do
        describe "filtering present" do
          subject(:report_present){BikeReport.new(:assigned => true, :present => true)}          
          it "has assets" do
            expect(report_present.assets).to_not be_empty
          end
          it "has data" do
            expect(report_present.data).to_not be_empty
          end
        end
      end
    end # context "filtering available"
    describe "filtering not assigned" do
      subject(:report){BikeReport.new(:available => true)}
      it "has no assets" do
        expect(report.assets).to be_empty
      end
    end # context "filtering available"
  end # context "when all bikes are assigned"

  context "with only an available bikes" do
    let!(:bike){FactoryGirl.create(:bike)}
    context "filtering assigned" do
      subject(:report){BikeReport.new(:assigned => true)}
      it "has no assets" do
        expect(report.assets).to be_empty
      end
    end # context "filtering assigned"

    context "filtering available" do
      subject(:report){BikeReport.new(:available => true)}
      it "has assets" do
        expect(report.assets).to_not be_empty
      end
    end
  end

  context "with mulitple programs" do
    let(:assignment_1){FactoryGirl.create(:assignment)}    
    let!(:bike1){assignment_1.bike}
    let(:prog1){bike1.program}
    let(:assignment_2){FactoryGirl.create(:assignment)}    
    let!(:bike2){assignment_2.bike}
    let!(:bike3){FactoryGirl.create(:bike)}
    
    context "filtering on first program" do
      subject(:report){BikeReport.new(:program => prog1.id)}
      it "includes the bike from the program" do
        expect(report.assets).to include(bike1)
      end
      it "does not include the bike from the other program" do
        expect(report.assets).to_not include(bike2)
      end
      it "does not include bikes not in the program" do
        expect(report.assets).to_not include(bike3)
      end
      it "has data" do
        expect(report.data).to_not be_empty
      end
    end

    context "filtering on second program" do
      subject(:report){BikeReport.new(:program => bike2.program.id)}
      it "includes the bike from the program" do
        expect(report.assets).to include(bike2)
      end
      it "has data" do
        expect(report.data).to_not be_empty
      end
      it "does not include the bike from the other program" do
        expect(report.assets).to_not include(bike1)
      end
      it "does not include bikes not in the program" do
        expect(report.assets).to_not include(bike3)
      end
    end

    context "filterin on both programs" do
      subject(:report){BikeReport.new(:program => [bike1.program.id, bike2.program.id])}
      it "includes bikes in each program" do
        expect(report.assets).to include(bike1)
        expect(report.assets).to include(bike2)
      end
      it "has data" do
        expect(report.data).to_not be_empty
      end
      it "does not include bikes not in either program" do
        expect(report.assets).to_not include(bike3)
      end
    end

    context "with bike assigned to a program and departed" do
      let(:bike4){FactoryGirl.create(:bike)}

      before :each do
        Assignment.build(:bike => bike4, :program => prog1).save!
        Departure.build(:bike => bike4.reload, :value => 0).save!
      end
    
      context "filtering on the program with the departed and non-departed bikes" do
        subject(:report){BikeReport.new(:program => prog1.id)}
        it "includes the departed bike" do
          expect(report.assets).to include(bike4)
        end
        it "includes the non-departed bike" do
          expect(report.assets).to include(bike1)
        end
        it "has data" do
          expect(report.data).to_not be_empty
        end
        it "does not include bikes not in the program" do
          expect(report.assets).to_not include(bike2)
        end
      end
    end # context "with bike assigned to a program and departed"
  end # context "with mulitple programs" 


  context "when all bikes are departed" do
    context "filtering not departed bikes" do
      let(:departure){FactoryGirl.create(:assignment_departed_dest)}
      let!(:bike){departure.bike}
      subject(:report){BikeReport.new(:present => true)}
      it "has no assets" do
        expect(report.assets).to be_empty
      end
    end # context "filtering not departed bikes"

    context "filtering departed bikes" do
      let(:departure){FactoryGirl.create(:assignment_departed_dest)}
      let!(:bike){departure.bike}
      subject(:report){BikeReport.new(:departed => true)}
      it "has departed bikes" do
        expect(Departure.count > 0).to be_truthy
      end
      it "has assets" do
        expect(report.assets).to_not be_empty
      end
      it "has data" do
        expect(report.data).to_not be_empty
      end
    end # context "filtering departed bikes"

  end #  context "with a departed bike seeded"
  
end
