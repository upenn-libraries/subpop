require 'rails_helper'

RSpec.describe PublicationData, type: :model do
  context 'factory' do
    it 'creates a PublicationData' do
      expect(create(:publication_data)).to be_a PublicationData
    end

    it 'builds a PublicationData without a publishable' do
      expect(build(:unassigned_publication_data)).to be_a PublicationData
    end
  end

  context 'initialization' do
    it 'creates a PublicationData' do
      expect(PublicationData.new).to be_a PublicationData
    end
  end
end
