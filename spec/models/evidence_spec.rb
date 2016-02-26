require 'rails_helper'

RSpec.describe Evidence, type: :model do
  context 'factories' do
    it "creates an evidence object" do
      expect(create(:evidence)).to be_a Evidence
    end

    it "creates evidence that's on flickr" do
      expect(create(:evidence_on_flickr)).to be_a Evidence
    end
  end

  context 'flickr_metadata' do
    it_behaves_like 'flickr_metadata'

  end
end
