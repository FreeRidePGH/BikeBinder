require 'spec_helper'

describe BikeNumber do

  describe "a new invalid number object" do

    it "should not be valid" do
      expect(BikeNumber.new('bad')).to_not be_valid
      expect(BikeNumber.new('12345A')).to_not be_valid
      expect(BikeNumber.new('123456')).to_not be_valid
      expect(BikeNumber.new('1234A')).to_not be_valid
      expect(BikeNumber.new('A12345')).to_not be_valid
      expect(BikeNumber.new('A1234')).to_not be_valid
      expect(BikeNumber.new('A12345')).to_not be_valid

    end
  end

  describe "a new valid number object" do
    it "should be valid" do
      expect(BikeNumber.new('12345')).to be_valid
    end
  end
end
