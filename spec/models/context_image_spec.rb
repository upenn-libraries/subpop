require 'rails_helper'

RSpec.describe ContextImage, type: :model do
  context 'factory' do
    it 'creates a ContextImage' do
      expect(create(:context_image)).to be_a(ContextImage)
    end
  end

  context 'initialization' do
    it 'creates a ContextImage' do
      expect(ContextImage.new).to be_a(ContextImage)
    end
  end

  context 'flickr_metadata' do
    it_behaves_like 'flickr_metadata'
  end

  context 'validations:' do
    it 'is valid' do
      expect(build(:context_image)).to be_valid
    end

    it 'is invalid without a book' do
      expect(build(:context_image, book: nil)).not_to be_valid
    end

  end
end
