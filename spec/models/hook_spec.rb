require 'spec_helper'

describe Hook do

  subject(:hook){FactoryGirl.create(:hook)}
  let(:hook2){FactoryGirl.create(:hook)}

  context "new" do
    it "finds by slug" do
      expect(Hook.find_by_slug(hook.slug)).to eq hook
    end

    it "does not find by the wrong slug" do
      expect(Hook.find_by_slug(hook2.slug)).to_not eq hook
    end

    it "is available" do
      expect(hook).to be_available
    end

    it "does not have a bike" do
      expect(hook.bike).to be_nil
    end

    it "is in the list of available hooks" do
      expect(Hook.available.include?(hook)).to be_true
    end

  end

  describe "::next_available" do
    context "at least 1 hook is available" do
      let(:hook){FactoryGirl.create(:hook)}
      subject(:next_avail){Hook.next_available}

      before :each do
        hook.save
      end

      it "is an available hook" do 
        expect(next_avail).to_not be_nil
        expect(next_avail).to be_available
      end
    end

    context "all hooks are reserved" do
      
      before :each do
        Hook.available.each do |h|
          HookReservation.new(
                              :bike => FactoryGirl.create(:bike),
                              :hook => h).save
        end
      end

      it "has no available hooks" do
        expect(Hook.available).to be_empty
        expect(Hook.next_available).to be_nil
      end
    end
  end # context "next available"

  context "with an assigned bike" do
    let(:reservation){FactoryGirl.create(:hook_reservation)}
    subject(:hook_from_res){reservation.hook}
    let(:bike_from_res){reservation.bike}

    it "is not available" do
      expect(hook_from_res).to_not be_available
    end

    it "references the correct bike" do
      expect(hook_from_res.bike).to_not be_nil
      expect(hook_from_res.bike).to eq bike_from_res
    end
  end

end
