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
  end

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
