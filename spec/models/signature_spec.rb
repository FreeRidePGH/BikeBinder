require 'rails_helper'

RSpec.describe Signature, :type=>:model do

  describe "finding or creating" do
    context "of existing record" do
      let(:name){"ABC"}
      let!(:existing){Signature.create(:uname => name)}
      subject(:sig){Signature.find_or_create(name)}
      
      it "is found" do
        expect(sig.id).to eq existing.id
      end
    end
    
    context "of new record" do
      let(:name0){"ABC"}
      let(:name){"DEF"}
      let!(:existing){Signature.find_or_create(name0)}
      subject(:sig){Signature.find_or_create(name)}
      
    it "is created" do
        expect(sig.id).to_not eq existing.id
      end
    end
  end # describe "finding or creating"

end
