require 'spec_helper'

describe HookReservation do 

  context "with given hook and bike" do
    let(:bike){ FactoryGirl.create(:bike) }
    let(:hook){ FactoryGirl.create(:hook) }
    subject(:reservation) {HookReservation.new(:bike => bike, :hook => hook)} 

    before :each do
      bike.hook_reservation = reservation
      hook.reservation = reservation
    end

    it "is valid" do
      expect(reservation).to be_valid
    end

    it "references the bike" do
      expect(reservation.bike).to_not be_nil
      expect(reservation.bike).to eq bike
    end

    it "references the hook" do
      expect(reservation.hook).to_not be_nil
      expect(reservation.hook).to eq hook
    end

    it "assigns the bike to the hook" do
      expect(bike.hook_reservation).to_not be_nil
      expect(bike.hook_reservation).to eq reservation
      expect(bike.hook).to eq(hook)
    end

    it "assigns the hook to the bike" do
      expect(hook.reservation).to_not be_nil
      expect(hook.reservation).to eq (reservation)
      expect(hook.bike).to eq(bike)
    end

    describe "bike_state" do
      it "is present" do
        expect(reservation).to be_bike_present
      end
    end
    describe "hook_sate" do
      it "is resolved" do
        expect(reservation).to be_hook_resolved
      end
    end
  end # created with hook and bike

  context "when bike departs" do
    subject(:reservation){FactoryGirl.build(:hook_reservation)}
    let(:bike){reservation.bike}
    let(:hook){reservation.hook}
    let(:dest){FactoryGirl.create(:destination)}
    let(:departure){Departure.build(:bike => bike, :destination => dest, :value => 0)}
        
    before :each do
      departure.save
    end

    it "vacates the hook" do
      expect(reservation).to_not be_persisted
      expect(hook.bike).to be_nil
      expect(bike.hook).to be_nil
    end

    context "reserves a hook" do
      let(:reservation_new){HookReservation.new(:bike => bike, :hook => hook)}
      before :each do
        reservation_new.save
      end
      it "is not valid" do
        expect(reservation_new).to_not be_valid
      end
      it "does not reserve the hook" do
        expect(hook.bike).to be_nil        
        expect(bike.hook).to be_nil
      end
    end
  end

  context "without a hook" do 

    subject(:reservation){FactoryGirl.build(:hook_reservation)}
    before :each do
      reservation.hook = nil
    end

    it "is not valid" do
      expect(reservation).to_not be_valid
    end
  end # without a hook

  context "without bike" do 
    subject(:reservation){FactoryGirl.build(:hook_reservation)}
    before :each do
      reservation.bike = nil
    end
    it "is not be valid" do
      expect(reservation).to_not be_valid
    end
  end # reserve without a bike

  describe "a hook has a conflict or issue" do
    before :each do
      @r =  FactoryGirl.build(:hook_reservation)
      @r.raise_issue_hook
    end
    it "should have a state of hook_blocked" do
      expect(@r).to be_hook_unresolved
    end
  end

  describe "a hook becomes unblocked" do
    before :each do
      @r = FactoryGirl.build(:hook_reservation)
      @r.resolve_hook
    end
    it "should have a state of hook_resolved" do
      expect(@r).to be_hook_resolved
    end
  end
  
  describe "a bike goes missing" do
    before :each do
      @r = FactoryGirl.build(:hook_reservation)
      @r.lose_bike
    end

    it "should have a state of bike_missing" do
      expect(@r).to be_bike_missing
    end
  end

  describe "a missing bike is found" do
    before :each do
      @r = FactoryGirl.build(:hook_reservation)
      @r.lose_bike
      @r.find_bike
    end

    it "should have a state of bike_present" do
      expect(@r).to be_bike_present
    end
  end

end
