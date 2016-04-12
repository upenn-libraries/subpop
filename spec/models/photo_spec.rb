require 'rails_helper'

RSpec.describe Photo, type: :model do
  context 'factory' do
    it 'creates a photo' do
      expect(create(:photo)).to be_a(Photo)
    end
  end

  context 'initialization' do
    it 'creates a photo' do
        expect(Photo.new).to be_a(Photo)
      end
  end
end
