require 'rails_helper'

RSpec.describe Evidence, type: :model do
  let(:subject) { create(:evidence) }
  context 'factories' do
    it "creates an evidence object" do
      expect(create(:evidence)).to be_a Evidence
    end

    it "creates evidence that's on flickr" do
      expect(create(:evidence_on_flickr)).to be_a Evidence
    end

    it 'creates a complete evidence instance' do
      expect(create(:evidence_complete)).to be_a Evidence
    end
  end

  context 'flickr_metadata' do
    it_behaves_like 'flickr_metadata'

  end

  context 'validations' do
    it 'is valid' do
      expect(subject).to be_valid
    end

    it "is not valid if format is 'other' and format_other is blank" do
      expect(build(:evidence, format: 'other', format_other: nil)).not_to be_valid
    end

    it "has an error on format_other if it is blank and format is 'other'" do
      evidence = build(:evidence, format: 'other', format_other: nil)
      evidence.valid?
      expect(evidence.errors[:format_other].size).to eq 1
    end
  end
end
