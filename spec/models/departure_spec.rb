require 'spec_helper'

#Departure
# id | user_id | bike_id | value | method_id | method_type |datetime_departed (would just be created_at)

 #Transaction
 #id | subtotal_value | payment_method_id  | departure_id

 #PayMethod
 #id | name (cash, check, vol credit)

# One nice thing about this is it could allow for a sale to be paid for in a combination of partial cash and partial volunteer credit. At Free Ride, people doing the earn-a-bike sometimes just fix the bike, do some of the required volunteering and then just pay the difference in cash. We also allow as-is purchases to be with volunteer credit or with cash. But we way that fix for sales need to be with cash.

describe Departure do

  context "without a bike" do
    subject(:departure){Departure.build(:bike => nil, :value => 0 )}
    it "is not valid" do
      expect(departure).to_not be_valid
    end
  end

  context "without an assigned bike or departure" do
    let(:bike){FactoryGirl.create(:bike)}
    subject(:departure){Departure.build(:bike => bike, :value => 0 )}
    it "is not valid" do
      expect(departure).to_not be_valid
    end
  end

  context "without a value specified" do
    let(:assignment){FactoryGirl.create(:assignment)}
    let(:bike){assignment.bike}
    subject(:departure){Departure.build(:bike => bike)}

    it "is not valid" do
      expect(departure).to_not be_valid
    end
  end

  context "a bike that is already departed" do
    let(:assignment){FactoryGirl.create(:assignment)}
    let(:bike){assignment.bike}
    let(:departure0){Departure.build(:bike => bike, :value => 0)}
    subject(:departure){Departure.build(:bike => bike, :value => 10)}

    before :each do
      departure0.save
    end

    it "already is departed" do
      expect(bike).to be_departed
    end

    it "is not new" do
      expect(departure).to be_persisted
    end

    it "is the same departure" do
      expect(departure).to eq departure0
    end
  end

  context "bike assigned to a program" do
    let(:assignment){FactoryGirl.create(:assignment)}
    let(:bike){assignment.bike}
    subject(:departure){Departure.build(:bike => bike, :value => 0)}

    before :each do
      departure.save
    end

    it "is valid" do
      expect(departure).to be_valid
    end

    it "associates the bike" do
      expect(departure.bike).to_not be_nil
      expect(bike.assignment).to_not be_nil
      expect(bike.application).to eq departure
    end
    
    it "departs the bike" do
      expect(departure.bike).to be_departed
    end

    it "has departed_at" do
      expect(departure.departed_at).to_not be_nil
    end

    it "records the final valid" do
      expect(departure.value).to_not be_nil
      expect(departure.value >= 0).to be_true
    end
    
    it "specifies the method" do
      expect(departure.method).to_not be_nil            
    end

    it "departs the bike" do
      expect(bike).to be_departed
    end

    it "makes the bike unavailable" do
      expect(bike).to_not be_available
    end

  end # context "with program"

  context "of bike with program on a hook" do

    let(:hook_reservation){FactoryGirl.create(:hook_reservation)}
    let(:bike){hook_reservation.bike}
    let(:hook){hook_reservation.hook}
    let(:program){FactoryGirl.create(:program)}
    subject(:departure) do
      assignment = Assignment.build(:bike => bike, :program => program)
      assignment.save
      Departure.build(:bike => assignment.bike.reload, :value => 0)
    end

    it "takes valid steps" do
      b = FactoryGirl.create(:bike)
      a = Assignment.new(:bike => b, :application => program)
      a.save
      bike.reload
      
      expect(a).to be_valid
      expect(a.bike).to eq b
      expect(b.assignment).to eq a

      d = Departure.build(:bike => b, :value => 0)
      expect(d).to be_valid
    end

    before :each do
      departure.save
    end

    it "is valid" do
      expect(departure).to be_valid
    end

    it "vacates the hook" do
      expect(bike.hook).to be_nil
    end

  end # context "bike with program and hook" do

  context "of an assigned bike" do
    let(:assignment){FactoryGirl.create(:assignment)}
    subject(:departure){Departure.build(:bike => assignment.bike, :value => 0)}

    before :each do
      departure.save
    end

    it "is valid" do
      expect(departure).to be_valid
    end

    it "specifies the assignemnt application as the method" do
      expect(departure.method).to_not be_nil
      expect(departure.method).to eq(assignment.application)
    end
  end # context "of an assigned bike"


  context "of a bike with a destination" do
    let(:dest){FactoryGirl.create(:destination)}
    let(:bike){FactoryGirl.create(:bike)}
    subject(:departure){Departure.build(:bike => bike, :destination => dest, :value => 0)}

    before :each do
      departure.save
      departure.reload
      bike.reload
    end

    it "is valid" do
      expect(departure).to be_valid
    end

    it "departs the bike" do
      expect(bike).to be_departed
    end

    it "makes the bike unavailable" do
      expect(bike).to_not be_available
    end

    it "assigns the destination to the bike as allotment method" do
      expect(bike.assignment.application.method).to eq dest
    end
  end # context "of a bike with a destination"

  context "of a bike and destination id parameter" do
    let(:dest){FactoryGirl.create(:destination)}
    let(:bike){FactoryGirl.create(:bike)}
    subject(:departure) do
      Departure.build(:bike => bike, 
                      :destination => dest.id,
                      :value => 0)
    end

    before :each do
      departure.save
      departure.reload
      bike.reload
    end

    it "is valid" do
      expect(departure).to be_valid
    end

    it "departs the bike" do
      expect(bike).to be_departed
    end

    it "makes the bike unavailable" do
      expect(bike).to_not be_available
    end

    it "assigns the destination to the bike as allotment method" do
      expect(bike.assignment.application.method.id).to eq dest.id
    end
  end

  context "of a scrapped bike" do
    # it "assigns bike.value=0"
  end # context "of a scrapped bike" do

end # describe Departure
