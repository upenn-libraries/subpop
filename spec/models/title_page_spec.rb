require 'rails_helper'

RSpec.describe TitlePage, type: :model do
  context 'factory' do
    it 'creates a TitlePage' do
      expect(create(:title_page)).to be_a(TitlePage)
    end
  end

  context 'initialization' do
    it 'creates a TitlePage' do
      expect(TitlePage.new).to be_a(TitlePage)
    end
  end

  context 'flickr_metadata' do
    it_behaves_like 'flickr_metadata'
  end

  context 'validations:' do
    it 'is valid' do
      expect(build(:title_page)).to be_valid
    end

    it 'is invalid without a book' do
      expect(build(:title_page, book: nil)).not_to be_valid
    end

  end
end
