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

    it "is not valid if format_other is present unles format is 'other'" do
      expect(build(:evidence, format: 'binding', format_other: 'ribbon')).not_to be_valid
    end

    it 'is valid if format_other is present and format is "other"' do
      expect(build(:evidence, format: 'other', format_other: 'ribbon')).to be_valid
    end

    it "is not valid if location is 'page_number' and location_in_book_page is blank" do
      expect(build(:evidence, location_in_book: 'page_number', location_in_book_page: nil)).not_to be_valid
    end

    it "has an error on location_in_book_page if it is blank and location is 'page_number'" do
      evidence = build(:evidence, location_in_book: 'page_number', location_in_book_page: nil)
      evidence.valid?
      expect(evidence.errors[:location_in_book_page].size).to eq 1
    end

    it "is not valid if location is not 'page_number' but location_in_book_page has a value" do
      expect(build(:evidence, location_in_book: 'front_cover', location_in_book_page: 'some page')).not_to be_valid
    end

    it 'is valid if location_in_book_page is present and location is "page_number"' do
      expect(build(:evidence, location_in_book: 'page_number', location_in_book_page: 'page 6')).to be_valid
    end
  end
end
